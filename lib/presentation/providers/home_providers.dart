import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/network/mock_music_data.dart';
import '../../domain/models/song.dart';
import '../../domain/models/playlist.dart';

final personalizedMixesProvider = Provider<List<Playlist>>((ref) {
  return MockMusicData.personalizedMixes;
});

final mostPlayedProvider = Provider<List<Song>>((ref) {
  return MockMusicData.mostPlayed;
});

final exploreNewProvider = Provider<List<Playlist>>((ref) {
  return MockMusicData.exploreNew;
});

final recentlyPlayedProvider = Provider<List<Song>>((ref) {
  return MockMusicData.recentlyPlayed;
});

final savedPlaylistsProvider = Provider<List<Playlist>>((ref) {
  return MockMusicData.savedPlaylists;
});
