import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';
import 'song_schema.dart';
import 'playlist_schema.dart';
import 'taste_profile_schema.dart';

/// Abre Isar una sola vez y lo expone como singleton.
///
/// USO EN main.dart:
///   await IsarService.init();      // antes de runApp()
///
/// USO EN cualquier repositorio:
///   final db = IsarService.instance;
///   final songs = await db.songSchemas.where().findAll();
class IsarService {
  IsarService._();

  static late final Isar instance;

  static Future<void> init() async {
    // path_provider da la carpeta de documentos del app en Android/iOS
    final dir = await getApplicationDocumentsDirectory();

    instance = await Isar.open(
      [
        SongSchemaSchema,
        PlaylistSchemaSchema,
        TasteProfileSchemaSchema,
      ],
      directory: dir.path,
      name: 'coretune_db',
    );
  }
}
