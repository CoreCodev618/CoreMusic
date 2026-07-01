import '../models/song.dart';

abstract class SongRepository {
  Future<List<Song>> search(String query);
  Future<List<Song>> getRecentlyPlayed();
  Future<List<Song>> getMostPlayed();
  Future<void> downloadSong(Song song);
}
