import 'package:flutter/material.dart';

/// Per-app brand tokens — register once in ThemeData.extensions.
///
/// ```dart
/// ThemeData(extensions: [
///   CalcwiseTheme.dark(primary: Color(0xFF818CF8), accent: Color(0xFFF59E0B)),
/// ])
/// ```
class CalcwiseTheme extends ThemeExtension<CalcwiseTheme> {
  const CalcwiseTheme({
    required this.surface,
    required this.surfaceHigh,
    required this.cardBorder,
    required this.textPrimary,
    required this.textSecondary,
    required this.primary,
    required this.primaryDeep,
    required this.accent,
    required this.successGreen,
    required this.errorRed,
    required this.ctaGradient,
    required this.heroGradient,
  });

  final Color surface, surfaceHigh, cardBorder;
  final Color textPrimary, textSecondary;
  final Color primary, primaryDeep, accent;
  final Color successGreen, errorRed;
  final LinearGradient ctaGradient, heroGradient;

  // ── Accessor ──────────────────────────────────────────────────────────────

  static CalcwiseTheme of(BuildContext context) {
    return Theme.of(context).extension<CalcwiseTheme>() ??
        CalcwiseTheme.dark(primary: Theme.of(context).colorScheme.primary);
  }

  // ── Dark preset (finance/productivity apps) ───────────────────────────────

  factory CalcwiseTheme.dark({
    Color  primary     = const Color(0xFF818CF8),
    Color? primaryDeep,
    Color  accent      = const Color(0xFFF59E0B),
    Color? secondaryDeep,
  }) {
    final deep1 = primaryDeep   ?? _darken(primary, 0.15);
    final deep2 = secondaryDeep ?? _darken(primary, 0.35);
    return CalcwiseTheme(
      surface:      const Color(0xFF161329),
      surfaceHigh:  const Color(0xFF1E1B35),
      cardBorder:   const Color(0xFF2E2B4A),
      textPrimary:  const Color(0xFFEDE9FF),
      textSecondary:const Color(0xFF8E8AB8),
      primary:      primary,
      primaryDeep:  deep1,
      accent:       accent,
      successGreen: const Color(0xFF34D399),
      errorRed:     const Color(0xFFEF4444),
      ctaGradient:  LinearGradient(colors: [deep1, deep2],
          begin: Alignment.centerLeft, end: Alignment.centerRight),
      heroGradient: LinearGradient(colors: [deep1, deep2],
          begin: Alignment.topLeft,   end: Alignment.bottomRight),
    );
  }

  // ── Light preset (real-estate / health apps) ──────────────────────────────

  factory CalcwiseTheme.light({
    Color  primary    = const Color(0xFF1565C0),
    Color  accent     = const Color(0xFFF59E0B),
    Color? primaryDeep,
    Color? secondaryDeep,
  }) {
    final deep = primaryDeep ?? _darken(primary, 0.2);
    return CalcwiseTheme(
      surface:      const Color(0xFFFFFFFF),
      surfaceHigh:  const Color(0xFFF8FAFC),
      cardBorder:   const Color(0xFFE2E8F0),
      textPrimary:  const Color(0xFF0F172A),
      textSecondary:const Color(0xFF64748B),
      primary:      primary,
      primaryDeep:  deep,
      accent:       accent,
      successGreen: const Color(0xFF059669),
      errorRed:     const Color(0xFFDC2626),
      ctaGradient:  LinearGradient(colors: [primary, deep],
          begin: Alignment.centerLeft, end: Alignment.centerRight),
      heroGradient: LinearGradient(colors: [primary, deep],
          begin: Alignment.topLeft,   end: Alignment.bottomRight),
    );
  }

  // ── ThemeExtension boilerplate ────────────────────────────────────────────

  @override
  CalcwiseTheme copyWith({
    Color? surface, Color? surfaceHigh, Color? cardBorder,
    Color? textPrimary, Color? textSecondary,
    Color? primary, Color? primaryDeep, Color? accent,
    Color? successGreen, Color? errorRed,
    LinearGradient? ctaGradient, LinearGradient? heroGradient,
  }) => CalcwiseTheme(
    surface:      surface       ?? this.surface,
    surfaceHigh:  surfaceHigh   ?? this.surfaceHigh,
    cardBorder:   cardBorder    ?? this.cardBorder,
    textPrimary:  textPrimary   ?? this.textPrimary,
    textSecondary:textSecondary ?? this.textSecondary,
    primary:      primary       ?? this.primary,
    primaryDeep:  primaryDeep   ?? this.primaryDeep,
    accent:       accent        ?? this.accent,
    successGreen: successGreen  ?? this.successGreen,
    errorRed:     errorRed      ?? this.errorRed,
    ctaGradient:  ctaGradient   ?? this.ctaGradient,
    heroGradient: heroGradient  ?? this.heroGradient,
  );

  @override
  CalcwiseTheme lerp(CalcwiseTheme? other, double t) {
    if (other == null) return this;
    return CalcwiseTheme(
      surface:      Color.lerp(surface,      other.surface,      t)!,
      surfaceHigh:  Color.lerp(surfaceHigh,  other.surfaceHigh,  t)!,
      cardBorder:   Color.lerp(cardBorder,   other.cardBorder,   t)!,
      textPrimary:  Color.lerp(textPrimary,  other.textPrimary,  t)!,
      textSecondary:Color.lerp(textSecondary,other.textSecondary,t)!,
      primary:      Color.lerp(primary,      other.primary,      t)!,
      primaryDeep:  Color.lerp(primaryDeep,  other.primaryDeep,  t)!,
      accent:       Color.lerp(accent,       other.accent,       t)!,
      successGreen: Color.lerp(successGreen, other.successGreen, t)!,
      errorRed:     Color.lerp(errorRed,     other.errorRed,     t)!,
      ctaGradient:  LinearGradient.lerp(ctaGradient,  other.ctaGradient,  t)!,
      heroGradient: LinearGradient.lerp(heroGradient, other.heroGradient, t)!,
    );
  }

  // ── Helper ────────────────────────────────────────────────────────────────

  static Color _darken(Color c, double amount) {
    final hsl = HSLColor.fromColor(c);
    return hsl.withLightness((hsl.lightness - amount).clamp(0.0, 1.0)).toColor();
  }
}
