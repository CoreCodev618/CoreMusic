import 'package:isar/isar.dart';

part 'playlist_schema.g.dart';

@collection
class PlaylistSchema {
  Id id = Isar.autoIncrement;

  @Index(unique: true)
  late String playlistId; // UUID generado en la app

  late String title;

  /// Lista de youtubeIds en orden de reproducción
  late List<String> songYoutubeIds;

  DateTime createdAt = DateTime.now();
}
