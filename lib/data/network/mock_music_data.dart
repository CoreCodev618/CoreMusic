import '../../domain/models/song.dart';
import '../../domain/models/playlist.dart';
import '../../domain/models/taste_profile.dart';

/// Fuente de datos mock. Se reemplaza por data/network y data/local_db
/// reales una vez conectado youtube_explode_dart + Isar.
class MockMusicData {
  MockMusicData._();

  static const List<Song> recentlyPlayed = [
    Song(
      id: 's1',
      title: 'Reflejos de neón',
      artist: 'Sintetwave Club',
      duration: Duration(minutes: 3, seconds: 24),
      genres: ['Synthwave'],
    ),
    Song(
      id: 's2',
      title: 'Camino al sur',
      artist: 'Andina Folk',
      duration: Duration(minutes: 4, seconds: 2),
      genres: ['Folk andino'],
      isDownloaded: true,
    ),
    Song(
      id: 's3',
      title: 'Marea baja',
      artist: 'Coastal Dreams',
      duration: Duration(minutes: 2, seconds: 51),
      genres: ['Lo-fi'],
    ),
  ];

  static const List<Song> mostPlayed = recentlyPlayed;

  static const List<Playlist> personalizedMixes = [
    Playlist(id: 'p1', title: 'Mix Synthwave'),
    Playlist(id: 'p2', title: 'Lo-fi nocturno'),
  ];

  static const List<Playlist> exploreNew = [
    Playlist(id: 'e1', title: 'Dream pop'),
    Playlist(id: 'e2', title: 'Cumbia psicodélica'),
  ];

  static const List<Playlist> savedPlaylists = [
    Playlist(id: 'sp1', title: 'Noches lo-fi'),
    Playlist(id: 'sp2', title: 'Para correr'),
  ];

  static const List<TasteOption> genreOptions = [
    TasteOption(id: 'g1', label: 'Synthwave', type: TasteOptionType.genre),
    TasteOption(id: 'g2', label: 'Folk andino', type: TasteOptionType.genre),
    TasteOption(id: 'g3', label: 'Lo-fi', type: TasteOptionType.genre),
    TasteOption(id: 'g4', label: 'Jazz', type: TasteOptionType.genre),
    TasteOption(id: 'g5', label: 'Rock', type: TasteOptionType.genre),
    TasteOption(id: 'g6', label: 'Electrónica', type: TasteOptionType.genre),
  ];

  static const List<TasteOption> artistOptions = [
    TasteOption(id: 'a1', label: 'Nocturna', type: TasteOptionType.artist),
    TasteOption(id: 'a2', label: 'Coastal Dreams', type: TasteOptionType.artist),
    TasteOption(id: 'a3', label: 'Andina Folk', type: TasteOptionType.artist),
  ];
}
