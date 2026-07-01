import 'package:isar/isar.dart';

// Este archivo genera: song_schema.g.dart
// Comando: dart run build_runner build -d
part 'song_schema.g.dart';

@collection
class SongSchema {
  Id id = Isar.autoIncrement;

  /// ID de YouTube (ej: "dQw4w9WgXcQ")
  @Index(unique: true)
  late String youtubeId;

  late String title;
  late String artist;
  String? albumArtUrl;
  late int durationSeconds;

  /// Géneros: ["Synthwave", "Lo-fi"]
  late List<String> genres;

  /// Descarga offline
  bool isDownloaded = false;
  String? localFilePath; // ruta completa en el celular

  /// Señales para el motor de IA
  int listenCount = 0;   // cuántas veces la escuchó completa
  int skipCount = 0;     // cuántas veces la saltó
  DateTime? lastPlayedAt;
}
