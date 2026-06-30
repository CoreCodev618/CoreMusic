import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/models/song.dart';
import '../../data/network/mock_music_data.dart';

class PlayerState {
  final Song? currentSong;
  final bool isPlaying;
  final Duration position;

  const PlayerState({
    this.currentSong,
    this.isPlaying = false,
    this.position = Duration.zero,
  });

  PlayerState copyWith({Song? currentSong, bool? isPlaying, Duration? position}) {
    return PlayerState(
      currentSong: currentSong ?? this.currentSong,
      isPlaying: isPlaying ?? this.isPlaying,
      position: position ?? this.position,
    );
  }
}

class PlayerController extends Notifier<PlayerState> {
  @override
  PlayerState build() {
    return PlayerState(currentSong: MockMusicData.recentlyPlayed.first);
  }

  void togglePlay() {
    state = state.copyWith(isPlaying: !state.isPlaying);
  }

  void playSong(Song song) {
    state = state.copyWith(currentSong: song, isPlaying: true);
  }
}

final playerControllerProvider =
    NotifierProvider<PlayerController, PlayerState>(PlayerController.new);
