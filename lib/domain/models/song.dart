/// Entidad de dominio: una canción, agnóstica de su origen (YouTube, local, etc).
class Song {
  final String id;
  final String title;
  final String artist;
  final String? albumArtUrl;
  final Duration duration;
  final List<String> genres;
  final bool isDownloaded;
  final String? localFilePath;

  const Song({
    required this.id,
    required this.title,
    required this.artist,
    required this.duration,
    this.albumArtUrl,
    this.genres = const [],
    this.isDownloaded = false,
    this.localFilePath,
  });
}
