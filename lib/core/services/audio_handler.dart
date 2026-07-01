import 'package:audio_service/audio_service.dart';
import 'package:just_audio/just_audio.dart';

import '../../domain/models/song.dart';
import '../../data/network/youtube_service.dart';

/// El corazón del reproductor de CoreTune.
///
/// Extiende BaseAudioHandler de audio_service, lo que da:
/// - Controles en la pantalla de bloqueo de Android
/// - Notificación persistente con play/pause/siguiente
/// - Reproducción en segundo plano (la música no para al minimizar la app)
///
/// Se registra UNA SOLA VEZ en main.dart con AudioService.init().
/// Los providers de Riverpod lo reciben por inyección.
class CoreTuneAudioHandler extends BaseAudioHandler
    with SeekHandler {
  final _player = AudioPlayer();
  final _youtube = YoutubeService();

  CoreTuneAudioHandler() {
    // Conectar el estado de just_audio con audio_service
    // para que los controles del sistema se actualicen solos
    _player.playbackEventStream
        .map(_buildPlaybackState)
        .pipe(playbackState);
  }

  // ─── REPRODUCCIÓN ─────────────────────────────────────────────────────────

  /// Carga y reproduce una canción.
  /// Si tiene archivo local (descargada) lo usa. Si no, busca en YouTube.
  Future<void> playSong(Song song) async {
    // 1. Actualizar la info que ve el sistema (lockscreen, notificación)
    mediaItem.add(MediaItem(
      id: song.id,
      title: song.title,
      artist: song.artist,
      duration: song.duration,
      artUri: song.albumArtUrl != null
          ? Uri.parse(song.albumArtUrl!)
          : null,
    ));

    // 2. Cargar la fuente de audio
    if (song.isDownloaded && song.localFilePath != null) {
      // Offline: archivo local descargado
      await _player.setFilePath(song.localFilePath!);
    } else {
      // Online: extraer URL de YouTube y hacer stream
      final url = await _youtube.getAudioStreamUrl(song.id);
      if (url == null) throw Exception('No se pudo obtener el stream de ${song.title}');
      await _player.setUrl(url);
    }

    // 3. Reproducir
    await _player.play();
  }

  // ─── CONTROLES ESTÁNDAR ───────────────────────────────────────────────────
  // audio_service los llama automáticamente desde la notificación y lockscreen

  @override
  Future<void> play() => _player.play();

  @override
  Future<void> pause() => _player.pause();

  @override
  Future<void> seek(Duration position) => _player.seek(position);

  @override
  Future<void> stop() async {
    await _player.stop();
    await super.stop();
  }

  // ─── STREAMS PARA RIVERPOD ───────────────────────────────────────────────
  // Los providers escuchan estos streams para actualizar la UI en tiempo real

  /// Posición actual de reproducción (se actualiza cada ~200ms)
  Stream<Duration> get positionStream => _player.positionStream;

  /// Estado del player (playing, paused, loading, completed)
  Stream<PlayerState> get playerStateStream => _player.playerStateStream;

  /// Si está reproduciendo en este momento
  bool get isPlaying => _player.playing;

  /// Duración total de la canción cargada
  Duration? get duration => _player.duration;

  // ─── CONSTRUCCIÓN DEL ESTADO ──────────────────────────────────────────────

  PlaybackState _buildPlaybackState(PlaybackEvent event) {
    final playing = _player.playing;

    return PlaybackState(
      controls: [
        MediaControl.skipToPrevious,
        if (playing) MediaControl.pause else MediaControl.play,
        MediaControl.skipToNext,
      ],
      systemActions: const {
        MediaAction.seek,
      },
      // Íconos compactos en la notificación de Android: anterior, play/pause, siguiente
      androidCompactActionIndices: const [0, 1, 2],
      processingState: const {
        ProcessingState.idle:      AudioProcessingState.idle,
        ProcessingState.loading:   AudioProcessingState.loading,
        ProcessingState.buffering: AudioProcessingState.buffering,
        ProcessingState.ready:     AudioProcessingState.ready,
        ProcessingState.completed: AudioProcessingState.completed,
      }[_player.processingState]!,
      playing: playing,
      updatePosition: _player.position,
      bufferedPosition: _player.bufferedPosition,
      speed: _player.speed,
    );
  }

  void dispose() {
    _player.dispose();
    _youtube.dispose();
  }
}
