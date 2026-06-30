import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_typography.dart';
import '../providers/taste_profile_providers.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final taste = ref.watch(tasteProfileProvider);

    return Scaffold(
      backgroundColor: CoreTuneColors.background,
      body: SafeArea(
        bottom: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Perfil', style: CoreTuneTypography.screenTitle),
              const SizedBox(height: 18),
              _Row(label: 'Géneros seleccionados', value: '${taste.selectedGenreIds.length}'),
              _Row(label: 'Artistas seleccionados', value: '${taste.selectedArtistIds.length}'),
              _Row(label: 'Onboarding completado', value: taste.onboardingCompleted ? 'Sí' : 'No'),
              const Spacer(),
              Padding(
                padding: const EdgeInsets.only(bottom: 20),
                child: Text(
                  'CoreTune · proyecto open-source · sin recolección de datos',
                  style: CoreTuneTypography.cardSubtitle,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _Row extends StatelessWidget {
  final String label;
  final String value;

  const _Row({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: CoreTuneTypography.body),
          Text(value, style: CoreTuneTypography.cardSubtitle),
        ],
      ),
    );
  }
}
