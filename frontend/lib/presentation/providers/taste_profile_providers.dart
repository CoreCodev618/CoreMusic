import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/models/taste_profile.dart';

class TasteProfileController extends Notifier<UserTasteProfile> {
  @override
  UserTasteProfile build() => const UserTasteProfile();

  void toggleGenre(String id) {
    final list = List<String>.from(state.selectedGenreIds);
    list.contains(id) ? list.remove(id) : list.add(id);
    state = state.copyWith(selectedGenreIds: list);
  }

  void toggleArtist(String id) {
    final list = List<String>.from(state.selectedArtistIds);
    list.contains(id) ? list.remove(id) : list.add(id);
    state = state.copyWith(selectedArtistIds: list);
  }

  void complete() {
    state = state.copyWith(onboardingCompleted: true);
  }

  void skip() {
    state = state.copyWith(onboardingSkipped: true);
  }
}

final tasteProfileProvider =
    NotifierProvider<TasteProfileController, UserTasteProfile>(
  TasteProfileController.new,
);
