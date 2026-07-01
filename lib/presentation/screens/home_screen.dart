import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_typography.dart';
import '../providers/home_providers.dart';
import '../widgets/music_card.dart';
import '../widgets/section_row.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final mixes = ref.watch(personalizedMixesProvider);
    final mostPlayed = ref.watch(mostPlayedProvider);
    final exploreNew = ref.watch(exploreNewProvider);
    final recentlyPlayed = ref.watch(recentlyPlayedProvider);

    return Scaffold(
      backgroundColor: CoreTuneColors.background,
      body: SafeArea(
        bottom: false,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Padding(
                padding: EdgeInsets.fromLTRB(20, 16, 20, 0),
                child: _Greeting(),
              ),
              const SizedBox(height: 14),

              SectionRow(
                title: 'Hecho para ti',
                icon: Icons.auto_awesome,
                iconColor: CoreTuneColors.amber,
                cards: [
                  for (final mix in mixes)
                    MusicCard(
                      title: mix.title,
                      subtitle: 'Por tus gustos',
                      size: 130,
                      outlined: true,
                    ),
                ],
              ),

              SectionRow(
                title: 'Tus más escuchados',
                cards: [
                  for (final song in mostPlayed)
                    MusicCard(title: song.title, subtitle: song.artist),
                ],
              ),

              SectionRow(
                title: 'Explorar nuevo',
                cards: [
                  for (final pl in exploreNew)
                    MusicCard(title: pl.title, subtitle: 'Nuevo para ti', outlined: true),
                ],
              ),

              SectionRow(
                title: 'Últimos escuchados',
                cards: [
                  for (final song in recentlyPlayed)
                    MusicCard(title: song.title, subtitle: song.artist),
                ],
              ),

              const SizedBox(height: 8),
            ],
          ),
        ),
      ),
    );
  }
}

class _Greeting extends StatelessWidget {
  const _Greeting();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Buenas noches', style: CoreTuneTypography.greeting),
        const SizedBox(height: 4),
        Text('Tu música', style: CoreTuneTypography.screenTitle),
      ],
    );
  }
}
