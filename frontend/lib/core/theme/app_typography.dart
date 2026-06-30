import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'app_colors.dart';

/// Fraunces para títulos editoriales, DM Sans para el resto de la UI.
class CoreTuneTypography {
  CoreTuneTypography._();

  static TextStyle get screenTitle => GoogleFonts.fraunces(
        fontSize: 22,
        fontWeight: FontWeight.w600,
        color: CoreTuneColors.textPrimary,
        height: 1.2,
      );

  static TextStyle get sectionLabel => GoogleFonts.dmSans(
        fontSize: 13,
        fontWeight: FontWeight.w500,
        color: CoreTuneColors.textSecondary,
        letterSpacing: 0.3,
      );

  static TextStyle get greeting => GoogleFonts.dmSans(
        fontSize: 12,
        fontWeight: FontWeight.w400,
        color: CoreTuneColors.textMuted,
      );

  static TextStyle get cardTitle => GoogleFonts.dmSans(
        fontSize: 13,
        fontWeight: FontWeight.w500,
        color: CoreTuneColors.textPrimary,
      );

  static TextStyle get cardSubtitle => GoogleFonts.dmSans(
        fontSize: 11,
        fontWeight: FontWeight.w400,
        color: CoreTuneColors.textMuted,
      );

  static TextStyle get body => GoogleFonts.dmSans(
        fontSize: 14,
        fontWeight: FontWeight.w400,
        color: CoreTuneColors.textPrimary,
      );

  static TextStyle get buttonLabel => GoogleFonts.dmSans(
        fontSize: 14,
        fontWeight: FontWeight.w500,
        color: CoreTuneColors.coralDark,
      );
}
