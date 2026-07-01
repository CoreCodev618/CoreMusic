import '../models/song.dart';
import '../models/playlist.dart';

/// Contrato del motor de recomendación on-device (embeddings + similitud
/// coseno). La implementación real vivirá en data/repositories_impl y
/// correrá completamente en el dispositivo, sin servidor.
abstract class RecommendationEngine {
  /// Mezclas generadas a partir del perfil de gustos del usuario.
  Future<List<Playlist>> getPersonalizedMixes();

  /// Sugerencias de géneros/artistas nuevos no escuchados aún, pero
  /// cercanos en el espacio de embeddings al gusto actual del usuario.
  Future<List<Song>> getExploreSuggestions();

  /// Se llama cada vez que el usuario escucha, salta o descarga una
  /// canción, para re-entrenar el vector de gustos incrementalmente.
  Future<void> registerInteraction(Song song, {required bool wasSkipped});
}
