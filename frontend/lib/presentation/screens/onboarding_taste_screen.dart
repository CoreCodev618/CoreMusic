import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_theme.dart';
import '../../core/theme/app_typography.dart';
import '../../data/network/mock_music_data.dart';
import '../providers/taste_profile_providers.dart';
import '../widgets/genre_taste_card.dart';

class OnboardingTasteScreen extends ConsumerWidget {
  const OnboardingTasteScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final taste = ref.watch(tasteProfileProvider);
    final controller = ref.read(tasteProfileProvider.notifier);

    return Scaffold(
      backgroundColor: CoreTuneColors.background,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Paso 1 de 2', style: CoreTuneTypography.greeting),
                        const SizedBox(height: 4),
                        Text('¿Qué te gusta escuchar?', style: CoreTuneTypography.screenTitle),
                        const SizedBox(height: 4),
                        Text(
                          'Elige los que más te representen',
                          style: CoreTuneTypography.cardSubtitle,
                        ),
                      ],
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      controller.skip();
                      Navigator.of(context).pushReplacementNamed('/home');
                    },
                    child: Text('Saltar', style: CoreTuneTypography.greeting),
                  ),
                ],
              ),
              const SizedBox(height: 18),
              Text('Géneros', style: CoreTuneTypography.sectionLabel),
              const SizedBox(height: 10),
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      GridView.count(
                        crossAxisCount: 2,
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        crossAxisSpacing: 10,
                        mainAxisSpacing: 10,
                        childAspectRatio: 2.1,
                        children: [
                          for (final genre in MockMusicData.genreOptions)
                            GenreTasteCard(
                              label: genre.label,
                              icon: iconForGenre(genre.label),
                              selected: taste.selectedGenreIds.contains(genre.id),
                              onTap: () => controller.toggleGenre(genre.id),
                            ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      Text('Artistas que te gustan', style: CoreTuneTypography.sectionLabel),
                      const SizedBox(height: 10),
                      SizedBox(
                        height: 96,
                        child: ListView.separated(
                          scrollDirection: Axis.horizontal,
                          itemCount: MockMusicData.artistOptions.length,
                          separatorBuilder: (_, __) => const SizedBox(width: 10),
                          itemBuilder: (context, i) {
                            final artist = MockMusicData.artistOptions[i];
                            return ArtistTasteAvatar(
                              label: artist.label,
                              selected: taste.selectedArtistIds.contains(artist.id),
                              onTap: () => controller.toggleArtist(artist.id),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 12),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: CoreTuneColors.coral,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(AppTheme.radiusLg),
                    ),
                  ),
                  onPressed: () {
                    controller.complete();
                    Navigator.of(context).pushReplacementNamed('/home');
                  },
                  child: Text('Continuar', style: CoreTuneTypography.buttonLabel),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
