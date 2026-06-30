import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_typography.dart';
import '../../core/utils/constants.dart';
import '../providers/player_providers.dart';

class PlayerScreen extends ConsumerWidget {
  const PlayerScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(playerControllerProvider);
    final song = state.currentSong;

    return Scaffold(
      backgroundColor: CoreTuneColors.background,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(24, 8, 24, 24),
          child: Column(
            children: [
              Row(
                children: [
                  IconButton(
                    onPressed: () => Navigator.of(context).maybePop(),
                    icon: const Icon(Icons.keyboard_arrow_down, color: CoreTuneColors.textPrimary),
                  ),
                  const Spacer(),
                  Text('Reproduciendo ahora', style: CoreTuneTypography.greeting),
                  const Spacer(),
                  const SizedBox(width: 48),
                ],
              ),
              const Spacer(),

              // Carátula del álbum.
              AspectRatio(
                aspectRatio: 1,
                child: Container(
                  decoration: BoxDecoration(
                    color: CoreTuneColors.surfaceAlt2,
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
              ),

              const SizedBox(height: 28),
              Text(
                song?.title ?? '—',
                style: CoreTuneTypography.screenTitle,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 6),
              Text(
                song?.artist ?? '',
                style: CoreTuneTypography.cardSubtitle,
                textAlign: TextAlign.center,
              ),

              const Spacer(),

              // Barra de progreso.
              Column(
                children: [
                  SliderTheme(
                    data: SliderTheme.of(context).copyWith(
                      activeTrackColor: CoreTuneColors.coral,
                      inactiveTrackColor: CoreTuneColors.surfaceAlt2,
                      thumbColor: CoreTuneColors.coral,
                      trackHeight: 3,
                      thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 6),
                    ),
                    child: Slider(
                      value: state.position.inSeconds.toDouble().clamp(
                            0,
                            (song?.duration.inSeconds ?? 1).toDouble(),
                          ),
                      max: (song?.duration.inSeconds ?? 1).toDouble(),
                      onChanged: (_) {},
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(TimeFormatter.mmss(state.position), style: CoreTuneTypography.cardSubtitle),
                        Text(
                          TimeFormatter.mmss(song?.duration ?? Duration.zero),
                          style: CoreTuneTypography.cardSubtitle,
                        ),
                      ],
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 12),

              // Controles principales, ubicados abajo para alcance con el pulgar.
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Icon(Icons.shuffle, color: CoreTuneColors.textMuted, size: 20),
                  const Icon(Icons.skip_previous, color: CoreTuneColors.textPrimary, size: 30),
                  GestureDetector(
                    onTap: () => ref.read(playerControllerProvider.notifier).togglePlay(),
                    child: Container(
                      width: 64,
                      height: 64,
                      decoration: const BoxDecoration(
                        color: CoreTuneColors.coral,
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        state.isPlaying ? Icons.pause : Icons.play_arrow,
                        color: CoreTuneColors.coralDark,
                        size: 30,
                      ),
                    ),
                  ),
                  const Icon(Icons.skip_next, color: CoreTuneColors.textPrimary, size: 30),
                  const Icon(Icons.repeat, color: CoreTuneColors.textMuted, size: 20),
                ],
              ),

              const SizedBox(height: 18),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Icon(Icons.download_outlined, color: CoreTuneColors.amber, size: 20),
                  Text('Letras', style: CoreTuneTypography.greeting),
                  const Icon(Icons.queue_music, color: CoreTuneColors.textMuted, size: 20),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
