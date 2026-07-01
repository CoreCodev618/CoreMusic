import 'package:flutter/material.dart';
import 'app_colors.dart';
import 'app_typography.dart';

class AppTheme {
  AppTheme._();

  static const double radiusSm = 10;
  static const double radiusMd = 12;
  static const double radiusLg = 14;

  static ThemeData get dark {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      scaffoldBackgroundColor: CoreTuneColors.background,
      fontFamily: 'DM Sans',
      colorScheme: const ColorScheme.dark(
        surface: CoreTuneColors.background,
        primary: CoreTuneColors.coral,
        secondary: CoreTuneColors.amber,
      ),
      textTheme: TextTheme(
        titleLarge: CoreTuneTypography.screenTitle,
        bodyMedium: CoreTuneTypography.body,
        labelSmall: CoreTuneTypography.cardSubtitle,
      ),
      iconTheme: const IconThemeData(color: CoreTuneColors.textMuted),
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: CoreTuneColors.backgroundDeep,
        selectedItemColor: CoreTuneColors.coral,
        unselectedItemColor: CoreTuneColors.textMuted,
        showSelectedLabels: false,
        showUnselectedLabels: false,
        type: BottomNavigationBarType.fixed,
        elevation: 0,
      ),
    );
  }
}
