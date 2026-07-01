import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/models/song.dart';
import '../../data/repositories_impl/song_repository_impl.dart';
import '../../core/services/audio_handler.dart';

// ─── PROVIDERS DE DEPENDENCIAS ───────────────────────────────────────────────

/// AudioHandler — se inyecta desde main.dart después de AudioService.init()
final audioHandlerProvider = Provider<CoreTuneAudioHandler>((ref) {
  throw UnimplementedError('Debe inyectarse en main.dart con overrideWithValue');
});

/// Repositorio de canciones real (Isar + YouTube)
final songRepositoryProvider = Provider<SongRepositoryImpl>((ref) {
  return SongRepositoryImpl();
});

// ─── ESTADO DEL REPRODUCTOR ───────────────────────────────────────────────

class PlayerState {
  final Song? currentSong;
  final bool isPlaying;
  final bool isLoading;
  final Duration position;
  final String? error;

  const PlayerState({
    this.currentSong,
    this.isPlaying = false,
    this.isLoading = false,
    this.position = Duration.zero,
    this.error,
  });

  PlayerState copyWith({
    Song? currentSong,
    bool? isPlaying,
    bool? isLoading,
    Duration? position,
    String? error,
  }) {
    return PlayerState(
      currentSong: currentSong ?? this.currentSong,
      isPlaying: isPlaying ?? this.isPlaying,
      isLoading: isLoading ?? this.isLoading,
      position: position ?? this.position,
      error: error,
    );
  }
}

// ─── CONTROLADOR ──────────────────────────────────────────────────────────

class PlayerController extends Notifier<PlayerState> {
  @override
  PlayerState build() => const PlayerState();

  /// Reproduce una canción. Llama esto desde SongTile o PlayerScreen.
  Future<void> playSong(Song song) async {
    // Mostrar estado de carga inmediatamente
    state = state.copyWith(
      currentSong: song,
      isLoading: true,
      isPlaying: false,
      error: null,
    );

    try {
      final handler = ref.read(audioHandlerProvider);
      await handler.playSong(song);

      state = state.copyWith(isLoading: false, isPlaying: true);

      // Escuchar posición en tiempo real
      handler.positionStream.listen((pos) {
        state = state.copyWith(position: pos);
      });

      // Registrar escucha en Isar (historial + señal para la IA)
      final repo = ref.read(songRepositoryProvider);
      await repo.registerListen(song);

    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        isPlaying: false,
        error: 'No se pudo reproducir. Intenta de nuevo.',
      );
    }
  }

  Future<void> togglePlay() async {
    final handler = ref.read(audioHandlerProvider);
    if (state.isPlaying) {
      await handler.pause();
    } else {
      await handler.play();
    }
    state = state.copyWith(isPlaying: !state.isPlaying);
  }

  Future<void> seek(Duration position) async {
    await ref.read(audioHandlerProvider).seek(position);
    state = state.copyWith(position: position);
  }

  /// Registra skip como señal negativa para la IA.
  Future<void> skipSong() async {
    final song = state.currentSong;
    if (song == null) return;
    final repo = ref.read(songRepositoryProvider);
    await repo.registerSkip(song);
  }
}

final playerControllerProvider =
    NotifierProvider<PlayerController, PlayerState>(PlayerController.new);
