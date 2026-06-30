import 'package:flutter/material.dart';
import '../../core/theme/app_typography.dart';

class SectionRow extends StatelessWidget {
  final String title;
  final IconData? icon;
  final Color? iconColor;
  final List<Widget> cards;

  const SectionRow({
    super.key,
    required this.title,
    required this.cards,
    this.icon,
    this.iconColor,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              children: [
                if (icon != null) ...[
                  Icon(icon, size: 14, color: iconColor),
                  const SizedBox(width: 6),
                ],
                Text(
                  title,
                  style: iconColor != null
                      ? CoreTuneTypography.sectionLabel.copyWith(color: iconColor)
                      : CoreTuneTypography.sectionLabel,
                ),
              ],
            ),
          ),
          const SizedBox(height: 8),
          SizedBox(
            height: cards.isNotEmpty ? null : 0,
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                children: [
                  for (final c in cards) Padding(
                    padding: const EdgeInsets.only(right: 10),
                    child: c,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
