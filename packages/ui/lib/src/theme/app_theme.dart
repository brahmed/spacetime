import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../constants/app_sizes.dart';
import 'app_colors.dart';

/// Factory for SpaceTime [ThemeData].
abstract final class AppTheme {
  static const _background = Color(0xFF080808);
  static const _surface    = Color(0xFF111111);
  static const _onSurface  = Color(0xFFF0F0F0);
  static const _accent     = Color(0xFFFFE500);

  static ThemeData get dark {
    final base = ThemeData.dark(useMaterial3: true);
    return base.copyWith(
      scaffoldBackgroundColor: _background,
      colorScheme: const ColorScheme.dark(
        primary:          _accent,
        onPrimary:        Color(0xFF080808),
        surface:          _surface,
        onSurface:        _onSurface,
        surfaceContainer: _surface,
        outline:          Color(0xFF222222),
      ),
      textTheme: GoogleFonts.dmSansTextTheme(base.textTheme).apply(
        bodyColor:    _onSurface,
        displayColor: _onSurface,
      ),
      cardTheme: CardThemeData(
        color: _surface,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(Sizes.radiusCard),
          side: const BorderSide(color: Color(0xFF222222)),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: _accent,
          foregroundColor: const Color(0xFF080808),
          minimumSize: const Size.fromHeight(48),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(Sizes.radiusButton),
          ),
          textStyle: GoogleFonts.dmSans(
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: _onSurface,
          minimumSize: const Size.fromHeight(48),
          side: const BorderSide(color: Color(0xFF333333)),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(Sizes.radiusButton),
          ),
          textStyle: GoogleFonts.dmSans(
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: _surface,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(Sizes.radiusButton),
          borderSide: const BorderSide(color: Color(0xFF222222)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(Sizes.radiusButton),
          borderSide: const BorderSide(color: Color(0xFF222222)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(Sizes.radiusButton),
          borderSide: const BorderSide(color: _accent),
        ),
        labelStyle: const TextStyle(color: Color(0xFF888888)),
        hintStyle: const TextStyle(color: Color(0xFF555555)),
      ),
      dividerTheme: const DividerThemeData(
        color: Color(0xFF222222),
        thickness: 1,
      ),
      extensions: const [AppColors.defaults],
    );
  }
}
