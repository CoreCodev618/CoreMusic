import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_theme.dart';
import '../../core/theme/app_typography.dart';
import '../../domain/models/taste_profile.dart';

class GenreTasteCard extends StatelessWidget {
  final String label;
  final IconData icon;
  final bool selected;
  final VoidCallback onTap;

  const GenreTasteCard({
    super.key,
    required this.label,
    required this.icon,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final accent = selected ? CoreTuneColors.coral : CoreTuneColors.borderStrong;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
        decoration: BoxDecoration(
          color: CoreTuneColors.surfaceCard,
          borderRadius: BorderRadius.circular(AppTheme.radiusMd),
          border: Border.all(color: accent, width: selected ? 2 : 1),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 18, color: selected ? CoreTuneColors.coral : CoreTuneColors.textSecondary),
            const SizedBox(height: 8),
            Text(label, style: CoreTuneTypography.cardTitle),
          ],
        ),
      ),
    );
  }
}

class ArtistTasteAvatar extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;

  const ArtistTasteAvatar({
    super.key,
    required this.label,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: SizedBox(
        width: 80,
        child: Column(
          children: [
            Container(
              width: 64,
              height: 64,
              decoration: BoxDecoration(
                color: CoreTuneColors.surfaceAlt2,
                shape: BoxShape.circle,
                border: Border.all(
                  color: selected ? CoreTuneColors.coral : CoreTuneColors.borderStrong,
                  width: selected ? 2 : 1,
                ),
              ),
            ),
            const SizedBox(height: 6),
            Text(
              label,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: CoreTuneTypography.cardSubtitle,
            ),
          ],
        ),
      ),
    );
  }
}

IconData iconForGenre(String label) {
  switch (label) {
    case 'Synthwave':
      return Icons.album;
    case 'Folk andino':
      return Icons.piano; // placeholder, ajustar con icon set final
    case 'Lo-fi':
      return Icons.mic_external_on;
    case 'Jazz':
      return Icons.piano;
    case 'Rock':
      return Icons.bolt;
    case 'Electrónica':
      return Icons.graphic_eq;
    default:
      return Icons.music_note;
  }
}
