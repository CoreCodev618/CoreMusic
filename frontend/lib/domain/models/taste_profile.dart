/// Tarjeta seleccionable del onboarding (género o artista).
class TasteOption {
  final String id;
  final String label;
  final TasteOptionType type;
  final String? imageUrl;

  const TasteOption({
    required this.id,
    required this.label,
    required this.type,
    this.imageUrl,
  });
}

enum TasteOptionType { genre, artist }

/// Perfil de gustos del usuario. El vector de embeddings real (para la
/// similitud coseno del motor de recomendación on-device) se calculará en
/// data/repositories_impl a partir de estas selecciones + historial.
class UserTasteProfile {
  final List<String> selectedGenreIds;
  final List<String> selectedArtistIds;
  final bool onboardingCompleted;
  final bool onboardingSkipped;
  final int listensSinceSkipped;

  const UserTasteProfile({
    this.selectedGenreIds = const [],
    this.selectedArtistIds = const [],
    this.onboardingCompleted = false,
    this.onboardingSkipped = false,
    this.listensSinceSkipped = 0,
  });

  UserTasteProfile copyWith({
    List<String>? selectedGenreIds,
    List<String>? selectedArtistIds,
    bool? onboardingCompleted,
    bool? onboardingSkipped,
    int? listensSinceSkipped,
  }) {
    return UserTasteProfile(
      selectedGenreIds: selectedGenreIds ?? this.selectedGenreIds,
      selectedArtistIds: selectedArtistIds ?? this.selectedArtistIds,
      onboardingCompleted: onboardingCompleted ?? this.onboardingCompleted,
      onboardingSkipped: onboardingSkipped ?? this.onboardingSkipped,
      listensSinceSkipped: listensSinceSkipped ?? this.listensSinceSkipped,
    );
  }
}
