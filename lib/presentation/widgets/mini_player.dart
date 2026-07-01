import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_typography.dart';
import '../providers/player_providers.dart';

class MiniPlayer extends ConsumerWidget {
  const MiniPlayer({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final playerState = ref.watch(playerControllerProvider);
    final song = playerState.currentSong;
    if (song == null) return const SizedBox.shrink();

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: const BoxDecoration(
        color: CoreTuneColors.surface,
        border: Border(top: BorderSide(color: CoreTuneColors.surfaceAlt2)),
      ),
      child: Row(
        children: [
          Container(
            width: 38,
            height: 38,
            decoration: BoxDecoration(
              color: CoreTuneColors.coral,
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  song.title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: CoreTuneTypography.cardTitle,
                ),
                Text(
                  song.artist,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: CoreTuneTypography.cardSubtitle,
                ),
              ],
            ),
          ),
          IconButton(
            icon: Icon(
              playerState.isPlaying ? Icons.pause : Icons.play_arrow,
              color: CoreTuneColors.amber,
            ),
            onPressed: () => ref.read(playerControllerProvider.notifier).togglePlay(),
          ),
          const Icon(Icons.skip_next, color: CoreTuneColors.textPrimary),
        ],
      ),
    );
  }
}
