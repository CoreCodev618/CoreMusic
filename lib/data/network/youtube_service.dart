import 'dart:io';
import 'package:youtube_explode_dart/youtube_explode_dart.dart';

/// Encapsula toda la interacción con youtube_explode_dart.
/// Solo lo usan los repositorios — nunca la UI directamente.
class YoutubeService {
  // Una sola instancia del cliente (mantiene conexiones HTTP abiertas)
  final _yt = YoutubeExplode();

  // ─── BÚSQUEDA ─────────────────────────────────────────────────────────────

  /// Busca canciones y retorna una lista de mapas con los metadatos.
  /// La conversión a Song (modelo de dominio) la hace el repositorio.
  ///
  /// Retorna hasta [maxResults] resultados.
  Future<List<YoutubeVideoResult>> search(
    String query, {
    int maxResults = 20,
  }) async {
    final results = await _yt.search.search(query);

    return results
        .whereType<Video>()
        .take(maxResults)
        .map(
          (v) => YoutubeVideoResult(
            id: v.id.value,
            title: v.title,
            author: v.author,
            thumbnailUrl: v.thumbnails.mediumResUrl,
            duration: v.duration ?? Duration.zero,
          ),
        )
        .toList();
  }

  // ─── STREAM DE AUDIO ──────────────────────────────────────────────────────

  /// Extrae la URL directa del stream de audio con mayor bitrate.
  /// Prioriza mp4a (AAC), cae a webm si no hay.
  /// Retorna null si no puede extraer (video restringido, sin audio, etc.).
  Future<String?> getAudioStreamUrl(String videoId) async {
    try {
      final manifest =
          await _yt.videos.streamsClient.getManifest(videoId);

      final streams = manifest.audioOnly.sortByBitrate();
      if (streams.isEmpty) return null;

      // El último después de sortByBitrate() es el de mayor calidad
      return streams.last.url.toString();
    } catch (e) {
      // Video no disponible, privado, o bloqueado por región
      return null;
    }
  }

  // ─── DESCARGA OFFLINE ────────────────────────────────────────────────────

  /// Descarga el audio de [videoId] al archivo [filePath].
  /// [filePath] viene de path_provider (ver SongRepositoryImpl).
  ///
  /// Uso:
  ///   final path = '${dir.path}/downloads/$videoId.m4a';
  ///   await youtubeService.downloadAudio(videoId, path);
  Future<void> downloadAudio(
    String videoId,
    String filePath, {
    void Function(double progress)? onProgress,
  }) async {
    final manifest =
        await _yt.videos.streamsClient.getManifest(videoId);

    final streamInfo = manifest.audioOnly.sortByBitrate().last;
    final totalSize = streamInfo.size.totalBytes;
    int downloaded = 0;

    final audioStream = _yt.videos.streamsClient.get(streamInfo);
    final sink = File(filePath).openWrite();

    await for (final chunk in audioStream) {
      sink.add(chunk);
      downloaded += chunk.length;

      // Callback opcional de progreso (para mostrar % en la UI)
      if (onProgress != null && totalSize > 0) {
        onProgress(downloaded / totalSize);
      }
    }

    await sink.close();
  }

  // ─── LIMPIEZA ─────────────────────────────────────────────────────────────

  /// Llamar en dispose() del repositorio para cerrar las conexiones HTTP.
  void dispose() => _yt.close();
}

/// Resultado crudo de YouTube antes de convertir al modelo de dominio.
class YoutubeVideoResult {
  final String id;
  final String title;
  final String author;
  final String thumbnailUrl;
  final Duration duration;

  const YoutubeVideoResult({
    required this.id,
    required this.title,
    required this.author,
    required this.thumbnailUrl,
    required this.duration,
  });
}
