import 'package:isar/isar.dart';

part 'taste_profile_schema.g.dart';

/// Documento único (id = 1). Guarda las selecciones del onboarding
/// y el vector de pesos de géneros que usa la IA on-device.
@collection
class TasteProfileSchema {
  Id id = 1; // singleton — siempre existe un solo perfil

  bool onboardingCompleted = false;
  bool onboardingSkipped = false;
  int listensSinceSkipped = 0;

  /// Géneros y artistas elegidos en el onboarding
  List<String> selectedGenreIds = [];
  List<String> selectedArtistIds = [];

  /// Vector de pesos por género para el motor de recomendación.
  /// Isar no soporta Map nativo, así que lo guardamos como JSON string.
  /// Ejemplo: '{"Synthwave":2.5,"Lo-fi":1.0,"Jazz":-0.3}'
  String genreWeightsJson = '{}';
}
