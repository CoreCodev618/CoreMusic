import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_theme.dart';
import '../../core/theme/app_typography.dart';

/// Tarjeta usada en "Hecho para ti", "Tus más escuchados", "Explorar nuevo"
/// y "Últimos escuchados" — todas comparten el mismo formato visual.
class MusicCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final double size;
  final bool outlined;
  final VoidCallback? onTap;

  const MusicCard({
    super.key,
    required this.title,
    required this.subtitle,
    this.size = 110,
    this.outlined = false,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: size,
        height: size,
        padding: const EdgeInsets.all(9),
        alignment: Alignment.bottomLeft,
        decoration: BoxDecoration(
          color: CoreTuneColors.surfaceCard,
          borderRadius: BorderRadius.circular(AppTheme.radiusMd),
          border: outlined
              ? Border.all(color: CoreTuneColors.borderStrong)
              : null,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: CoreTuneTypography.cardTitle,
            ),
            const SizedBox(height: 2),
            Text(
              subtitle,
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
