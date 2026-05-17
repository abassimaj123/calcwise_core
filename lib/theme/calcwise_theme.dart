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
    required this.successGreenSoft,
    required this.warningOrange,
    required this.warningOrangeSoft,
    required this.errorRed,
    required this.errorRedSoft,
    required this.ctaGradient,
    required this.heroGradient,
  });

  final Color surface, surfaceHigh, cardBorder;
  final Color textPrimary, textSecondary;
  final Color primary, primaryDeep, accent;
  final Color successGreen, successGreenSoft;
  final Color warningOrange, warningOrangeSoft;
  final Color errorRed, errorRedSoft;
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
    final base  = _darkSurfaceBase(primary);
    const successGreen  = Color(0xFF66BB6A);
    const warningOrange = Color(0xFFFFA726);
    const errorRed      = Color(0xFFEF5350);
    return CalcwiseTheme(
      surface:      base.toColor(),
      surfaceHigh:  base.withLightness(0.12).toColor(),
      cardBorder:   base.withLightness(0.22).toColor(),
      textPrimary:  const Color(0xFFFFFFFF).withAlpha(235),
      textSecondary:const Color(0xFFFFFFFF).withAlpha(160),
      primary:      primary,
      primaryDeep:  deep1,
      accent:       accent,
      successGreen:      successGreen,
      successGreenSoft:  _softDark(successGreen),
      warningOrange:     warningOrange,
      warningOrangeSoft: _softDark(warningOrange),
      errorRed:          errorRed,
      errorRedSoft:      _softDark(errorRed),
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
      successGreen:      const Color(0xFF2E7D32),
      successGreenSoft:  const Color(0xFFE8F5E9),
      warningOrange:     const Color(0xFFE65100),
      warningOrangeSoft: const Color(0xFFFFF3E0),
      errorRed:          const Color(0xFFC62828),
      errorRedSoft:      const Color(0xFFFFEBEE),
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
    Color? successGreen, Color? successGreenSoft,
    Color? warningOrange, Color? warningOrangeSoft,
    Color? errorRed, Color? errorRedSoft,
    LinearGradient? ctaGradient, LinearGradient? heroGradient,
  }) => CalcwiseTheme(
    surface:           surface           ?? this.surface,
    surfaceHigh:       surfaceHigh       ?? this.surfaceHigh,
    cardBorder:        cardBorder        ?? this.cardBorder,
    textPrimary:       textPrimary       ?? this.textPrimary,
    textSecondary:     textSecondary     ?? this.textSecondary,
    primary:           primary           ?? this.primary,
    primaryDeep:       primaryDeep       ?? this.primaryDeep,
    accent:            accent            ?? this.accent,
    successGreen:      successGreen      ?? this.successGreen,
    successGreenSoft:  successGreenSoft  ?? this.successGreenSoft,
    warningOrange:     warningOrange     ?? this.warningOrange,
    warningOrangeSoft: warningOrangeSoft ?? this.warningOrangeSoft,
    errorRed:          errorRed          ?? this.errorRed,
    errorRedSoft:      errorRedSoft      ?? this.errorRedSoft,
    ctaGradient:       ctaGradient       ?? this.ctaGradient,
    heroGradient:      heroGradient      ?? this.heroGradient,
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
      successGreen:      Color.lerp(successGreen,      other.successGreen,      t)!,
      successGreenSoft:  Color.lerp(successGreenSoft,  other.successGreenSoft,  t)!,
      warningOrange:     Color.lerp(warningOrange,     other.warningOrange,     t)!,
      warningOrangeSoft: Color.lerp(warningOrangeSoft, other.warningOrangeSoft, t)!,
      errorRed:          Color.lerp(errorRed,          other.errorRed,          t)!,
      errorRedSoft:      Color.lerp(errorRedSoft,      other.errorRedSoft,      t)!,
      ctaGradient:       LinearGradient.lerp(ctaGradient,  other.ctaGradient,  t)!,
      heroGradient:      LinearGradient.lerp(heroGradient, other.heroGradient, t)!,
    );
  }

  // ── Helper ────────────────────────────────────────────────────────────────

  static Color _darken(Color c, double amount) {
    final hsl = HSLColor.fromColor(c);
    return hsl.withLightness((hsl.lightness - amount).clamp(0.0, 1.0)).toColor();
  }

  static HSLColor _darkSurfaceBase(Color brand) {
    final hsl = HSLColor.fromColor(brand);
    return HSLColor.fromAHSL(
      1.0,
      hsl.hue,
      (hsl.saturation * 0.3).clamp(0.0, 0.25),
      0.08,
    );
  }

  static Color _softDark(Color brand) {
    final hsl = HSLColor.fromColor(brand);
    return HSLColor.fromAHSL(1.0, hsl.hue, 0.35, 0.16).toColor();
  }
}
