import 'dart:io';
import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';

import '../../domain/models/song.dart';
import '../../domain/repositories/song_repository.dart';
import '../local_db/isar_service.dart';
import '../local_db/song_schema.dart';
import '../network/youtube_service.dart';

class SongRepositoryImpl implements SongRepository {
  final _youtube = YoutubeService();

  // Acceso rápido a la instancia de Isar
  Isar get _db => IsarService.instance;

  // ─── BÚSQUEDA ─────────────────────────────────────────────────────────────
  @override
  Future<List<Song>> search(String query) async {
    final results = await _youtube.search(query);
    return results.map(_resultToModel).toList();
  }

  // ─── HISTORIAL ────────────────────────────────────────────────────────────

  /// Últimas canciones reproducidas, ordenadas por fecha (más reciente primero).
  @override
  Future<List<Song>> getRecentlyPlayed() async {
    final schemas = await _db.songSchemas
        .filter()
        .lastPlayedAtIsNotNull()
        .sortByLastPlayedAtDesc()
        .limit(20)
        .findAll();

    return schemas.map(_schemaToModel).toList();
  }

  /// Canciones más reproducidas, ordenadas por cantidad de escuchas.
  @override
  Future<List<Song>> getMostPlayed() async {
    final schemas = await _db.songSchemas
        .filter()
        .listenCountGreaterThan(0)
        .sortByListenCountDesc()
        .limit(20)
        .findAll();

    return schemas.map(_schemaToModel).toList();
  }

  // ─── INTERACCIONES (alimentan la IA) ─────────────────────────────────────

  /// Llama esto cuando el usuario reproduce una canción.
  /// Si la canción no existe en Isar la crea. Si existe, suma +1 al contador.
  Future<void> registerListen(Song song) async {
    await _db.writeTxn(() async {
      final existing = await _findByYoutubeId(song.id);

      if (existing != null) {
        existing.listenCount++;
        existing.lastPlayedAt = DateTime.now();
        await _db.songSchemas.put(existing);
      } else {
        // Primera vez que se escucha → crear en Isar
        final schema = _modelToSchema(song)
          ..listenCount = 1
          ..lastPlayedAt = DateTime.now();
        await _db.songSchemas.put(schema);
      }
    });
  }

  /// Llama esto cuando el usuario salta una canción.
  /// El RecommendationEngine usa skipCount como señal negativa.
  Future<void> registerSkip(Song song) async {
    await _db.writeTxn(() async {
      final existing = await _findByYoutubeId(song.id);

      if (existing != null) {
        existing.skipCount++;
        await _db.songSchemas.put(existing);
      } else {
        final schema = _modelToSchema(song)..skipCount = 1;
        await _db.songSchemas.put(schema);
      }
    });
  }

  // ─── DESCARGAS OFFLINE ────────────────────────────────────────────────────

  /// Descarga el audio al almacenamiento local y guarda la ruta en Isar.
  /// [onProgress] es opcional — úsalo para mostrar una barra de progreso en la UI.
  ///
  /// Después de esto, la canción se puede reproducir sin internet desde
  /// song.localFilePath, sin pasar por YouTube.
  @override
  Future<void> downloadSong(
    Song song, {
    void Function(double progress)? onProgress,
  }) async {
    final dir = await getApplicationDocumentsDirectory();
    final downloadsDir = Directory('${dir.path}/downloads');
    await downloadsDir.create(recursive: true);

    final filePath = '${downloadsDir.path}/${song.id}.m4a';

    await _youtube.downloadAudio(song.id, filePath, onProgress: onProgress);

    // Registrar la ruta en Isar
    await _db.writeTxn(() async {
      final existing = await _findByYoutubeId(song.id) ?? _modelToSchema(song);
      existing.isDownloaded = true;
      existing.localFilePath = filePath;
      await _db.songSchemas.put(existing);
    });
  }

  /// Canciones ya descargadas en el dispositivo (para LibraryScreen).
  Future<List<Song>> getDownloadedSongs() async {
    final schemas = await _db.songSchemas
        .filter()
        .isDownloadedEqualTo(true)
        .findAll();

    return schemas.map(_schemaToModel).toList();
  }

  /// Elimina el archivo local y marca la canción como no descargada en Isar.
  Future<void> deleteDownload(Song song) async {
    if (song.localFilePath != null) {
      final file = File(song.localFilePath!);
      if (await file.exists()) await file.delete();
    }

    await _db.writeTxn(() async {
      final existing = await _findByYoutubeId(song.id);
      if (existing != null) {
        existing.isDownloaded = false;
        existing.localFilePath = null;
        await _db.songSchemas.put(existing);
      }
    });
  }

  // ─── HELPERS PRIVADOS ─────────────────────────────────────────────────────

  Future<SongSchema?> _findByYoutubeId(String youtubeId) {
    return _db.songSchemas
        .filter()
        .youtubeIdEqualTo(youtubeId)
        .findFirst();
  }

  // YoutubeVideoResult → Song (modelo de dominio)
  Song _resultToModel(YoutubeVideoResult r) => Song(
        id: r.id,
        title: r.title,
        artist: r.author,
        albumArtUrl: r.thumbnailUrl,
        duration: r.duration,
      );

  // SongSchema (Isar) → Song (modelo de dominio)
  Song _schemaToModel(SongSchema s) => Song(
        id: s.youtubeId,
        title: s.title,
        artist: s.artist,
        albumArtUrl: s.albumArtUrl,
        duration: Duration(seconds: s.durationSeconds),
        genres: s.genres,
        isDownloaded: s.isDownloaded,
        localFilePath: s.localFilePath,
      );

  // Song (modelo de dominio) → SongSchema (Isar)
  SongSchema _modelToSchema(Song s) => SongSchema()
    ..youtubeId = s.id
    ..title = s.title
    ..artist = s.artist
    ..albumArtUrl = s.albumArtUrl
    ..durationSeconds = s.duration.inSeconds
    ..genres = s.genres;

  void dispose() => _youtube.dispose();
}
