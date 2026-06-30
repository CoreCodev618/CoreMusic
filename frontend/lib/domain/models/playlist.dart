import 'song.dart';

class Playlist {
  final String id;
  final String title;
  final List<Song> songs;
  final String? coverColorHex;

  const Playlist({
    required this.id,
    required this.title,
    this.songs = const [],
    this.coverColorHex,
  });
}
