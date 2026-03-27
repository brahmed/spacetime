import 'package:flutter/material.dart';

/// Custom color tokens for the SpaceTime neon dark aesthetic.
/// Access via [AppThemeExtension.appColors]:
/// ```dart
/// Theme.of(context).appColors.accent
/// ```
@immutable
class AppColors extends ThemeExtension<AppColors> {
  const AppColors({
    required this.accent,
    required this.success,
    required this.warning,
    required this.danger,
    required this.surfaceDark,
    required this.borderSubtle,
    required this.textMuted,
  });

  final Color accent;       // #FFE500 — neon yellow, primary action
  final Color success;      // #39FF14 — neon green, confirmed state
  final Color warning;      // #FF9500 — orange, pending state
  final Color danger;       // #FF3131 — neon red, cancelled/destructive
  final Color surfaceDark;  // #111111 — card background
  final Color borderSubtle; // #222222 — subtle borders
  final Color textMuted;    // #888888 — secondary text

  /// Default tokens for dark theme.
  static const defaults = AppColors(
    accent:       Color(0xFFFFE500),
    success:      Color(0xFF39FF14),
    warning:      Color(0xFFFF9500),
    danger:       Color(0xFFFF3131),
    surfaceDark:  Color(0xFF111111),
    borderSubtle: Color(0xFF222222),
    textMuted:    Color(0xFF888888),
  );

  @override
  AppColors copyWith({
    Color? accent,
    Color? success,
    Color? warning,
    Color? danger,
    Color? surfaceDark,
    Color? borderSubtle,
    Color? textMuted,
  }) =>
      AppColors(
        accent:       accent       ?? this.accent,
        success:      success      ?? this.success,
        warning:      warning      ?? this.warning,
        danger:       danger       ?? this.danger,
        surfaceDark:  surfaceDark  ?? this.surfaceDark,
        borderSubtle: borderSubtle ?? this.borderSubtle,
        textMuted:    textMuted    ?? this.textMuted,
      );

  @override
  AppColors lerp(ThemeExtension<AppColors>? other, double t) {
    if (other is! AppColors) return this;
    return AppColors(
      accent:       Color.lerp(accent,       other.accent,       t)!,
      success:      Color.lerp(success,      other.success,      t)!,
      warning:      Color.lerp(warning,      other.warning,      t)!,
      danger:       Color.lerp(danger,       other.danger,       t)!,
      surfaceDark:  Color.lerp(surfaceDark,  other.surfaceDark,  t)!,
      borderSubtle: Color.lerp(borderSubtle, other.borderSubtle, t)!,
      textMuted:    Color.lerp(textMuted,    other.textMuted,    t)!,
    );
  }
}

/// Convenience extension for clean access to [AppColors].
extension AppThemeExtension on ThemeData {
  AppColors get appColors => extension<AppColors>()!;
}
