import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_typography.dart';
import '../../domain/models/song.dart';
import '../providers/player_providers.dart';

class SongTile extends ConsumerWidget {
  final Song song;

  const SongTile({super.key, required this.song});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return InkWell(
      onTap: () => ref.read(playerControllerProvider.notifier).playSong(song),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Row(
          children: [
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: CoreTuneColors.surfaceAlt2,
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(song.title, style: CoreTuneTypography.cardTitle),
                  const SizedBox(height: 2),
                  Text(song.artist, style: CoreTuneTypography.greeting),
                ],
              ),
            ),
            Icon(
              song.isDownloaded ? Icons.download_done : Icons.download_outlined,
              size: 18,
              color: song.isDownloaded ? CoreTuneColors.amber : CoreTuneColors.textMuted,
            ),
          ],
        ),
      ),
    );
  }
}
