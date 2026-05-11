import 'package:flutter/material.dart';
import 'calcwise_theme.dart';

/// Builds consistent ThemeData for all Calcwise portfolio apps.
///
/// Usage in AppTheme:
/// ```dart
/// static ThemeData get theme => CalcwiseThemeFactory.buildLight(primary: primary, accent: accent);
/// static ThemeData get dark  => CalcwiseThemeFactory.buildDark(primary: primary, accent: accent);
/// ```
/// Then in MaterialApp:
/// ```dart
/// theme: AppTheme.theme,
/// darkTheme: AppTheme.dark,
/// themeMode: ThemeMode.system,
/// ```
class CalcwiseThemeFactory {
  CalcwiseThemeFactory._();

  // ── Dark palette constants ──────────────────────────────────────────────────
  static const _bgDark          = Color(0xFF0D0B1E);
  static const _surfaceDark     = Color(0xFF161329);
  static const _surfaceHighDark = Color(0xFF1E1B35);
  static const _borderDark      = Color(0xFF2E2B4A);
  static const _textPriDark     = Color(0xFFEDE9FF);
  static const _textSecDark     = Color(0xFF8E8AB8);

  // ── Light palette constants ─────────────────────────────────────────────────
  static const _bgLight          = Color(0xFFF5F3FF);
  static const _surfaceLight     = Color(0xFFFFFFFF);
  static const _surfaceHighLight = Color(0xFFEEF0FF);
  static const _borderLight      = Color(0xFFDDD8F5);
  static const _textPriLight     = Color(0xFF1A1340);
  static const _textSecLight     = Color(0xFF6B6A8E);

  // ── Dark ThemeData ──────────────────────────────────────────────────────────

  static ThemeData buildDark({
    required Color primary,
    Color accent = const Color(0xFFF59E0B),
    Color? primaryDeep,
    Color? secondaryDeep,
  }) {
    final deep1 = primaryDeep   ?? _darken(primary, 0.15);
    final deep2 = secondaryDeep ?? _darken(primary, 0.35);
    final ct = CalcwiseTheme.dark(
      primary: primary, accent: accent,
      primaryDeep: deep1, secondaryDeep: deep2,
    );
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      scaffoldBackgroundColor: _bgDark,
      colorScheme: ColorScheme.dark(
        primary: primary,
        secondary: accent,
        surface: _surfaceDark,
        error: const Color(0xFFEF4444),
        onPrimary: Colors.white,
        onSurface: _textPriDark,
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: _bgDark,
        foregroundColor: _textPriDark,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: false,
        titleTextStyle: TextStyle(
          color: _textPriDark, fontSize: 19,
          fontWeight: FontWeight.w700, letterSpacing: -0.3,
        ),
      ),
      cardTheme: CardThemeData(
        color: _surfaceHighDark,
        elevation: 0,
        margin: EdgeInsets.zero,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: const BorderSide(color: _borderDark),
        ),
        surfaceTintColor: Colors.transparent,
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: _surfaceHighDark,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: _borderDark),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: _borderDark),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: primary, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFFEF4444)),
        ),
        labelStyle: const TextStyle(
            color: _textSecDark, fontSize: 13, fontWeight: FontWeight.w500),
        hintStyle: const TextStyle(color: Color(0xFF5A576E)),
        contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 13),
        prefixIconColor: _textSecDark,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primary,
          foregroundColor: Colors.white,
          minimumSize: const Size.fromHeight(52),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
          elevation: 0,
          textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(foregroundColor: primary),
      ),
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: _surfaceDark,
        indicatorColor: primary.withValues(alpha: 0.2),
        labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
        iconTheme: WidgetStateProperty.resolveWith((s) => IconThemeData(
          color: s.contains(WidgetState.selected) ? primary : _textSecDark,
        )),
        labelTextStyle: WidgetStateProperty.resolveWith((s) => TextStyle(
          color: s.contains(WidgetState.selected) ? primary : _textSecDark,
          fontSize: 12,
          fontWeight: s.contains(WidgetState.selected)
              ? FontWeight.w600 : FontWeight.normal,
        )),
      ),
      textTheme: const TextTheme(
        displayLarge:  TextStyle(color: _textPriDark, fontWeight: FontWeight.w800, fontSize: 32, letterSpacing: -0.5),
        titleLarge:    TextStyle(color: _textPriDark, fontWeight: FontWeight.w700, fontSize: 20),
        titleMedium:   TextStyle(color: _textPriDark, fontWeight: FontWeight.w600, fontSize: 16),
        titleSmall:    TextStyle(color: _textSecDark, fontWeight: FontWeight.w500, fontSize: 13),
        bodyLarge:     TextStyle(color: _textPriDark, fontSize: 16, height: 1.5),
        bodyMedium:    TextStyle(color: _textSecDark, fontSize: 14, height: 1.5),
        labelLarge:    TextStyle(color: Colors.white,  fontWeight: FontWeight.w600, fontSize: 15),
      ),
      dividerTheme: const DividerThemeData(color: _borderDark, space: 1, thickness: 1),
      listTileTheme: const ListTileThemeData(textColor: _textPriDark),
      switchTheme: SwitchThemeData(
        thumbColor: WidgetStateProperty.resolveWith((s) =>
            s.contains(WidgetState.selected) ? Colors.white : _textSecDark),
        trackColor: WidgetStateProperty.resolveWith((s) =>
            s.contains(WidgetState.selected)
                ? const Color(0xFF34D399).withValues(alpha: 0.5)
                : _surfaceHighDark),
      ),
      extensions: [ct],
    );
  }

  // ── Light ThemeData ─────────────────────────────────────────────────────────

  static ThemeData buildLight({
    required Color primary,
    Color accent = const Color(0xFFF59E0B),
    Color? primaryDeep,
  }) {
    final deep = primaryDeep ?? _darken(primary, 0.2);
    final ct = CalcwiseTheme.light(
      primary: primary, accent: accent, primaryDeep: deep,
    );
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      scaffoldBackgroundColor: _bgLight,
      colorScheme: ColorScheme.light(
        primary: primary,
        secondary: accent,
        surface: _surfaceLight,
        error: const Color(0xFFDC2626),
        onPrimary: Colors.white,
        onSurface: _textPriLight,
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: _bgLight,
        foregroundColor: _textPriLight,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: false,
        surfaceTintColor: Colors.transparent,
        titleTextStyle: TextStyle(
          color: _textPriLight, fontSize: 19,
          fontWeight: FontWeight.w700, letterSpacing: -0.3,
        ),
      ),
      cardTheme: CardThemeData(
        color: _surfaceLight,
        elevation: 0,
        margin: EdgeInsets.zero,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: const BorderSide(color: _borderLight),
        ),
        surfaceTintColor: Colors.transparent,
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: _surfaceHighLight,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: _borderLight),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: _borderLight),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: primary, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFFDC2626)),
        ),
        labelStyle: const TextStyle(
            color: _textSecLight, fontSize: 13, fontWeight: FontWeight.w500),
        hintStyle: const TextStyle(color: Color(0xFF9B99C0)),
        contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 13),
        prefixIconColor: _textSecLight,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primary,
          foregroundColor: Colors.white,
          minimumSize: const Size.fromHeight(52),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
          elevation: 0,
          textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(foregroundColor: primary),
      ),
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: _surfaceLight,
        indicatorColor: primary.withValues(alpha: 0.12),
        labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
        iconTheme: WidgetStateProperty.resolveWith((s) => IconThemeData(
          color: s.contains(WidgetState.selected) ? primary : _textSecLight,
        )),
        labelTextStyle: WidgetStateProperty.resolveWith((s) => TextStyle(
          color: s.contains(WidgetState.selected) ? primary : _textSecLight,
          fontSize: 12,
          fontWeight: s.contains(WidgetState.selected)
              ? FontWeight.w600 : FontWeight.normal,
        )),
      ),
      textTheme: const TextTheme(
        displayLarge:  TextStyle(color: _textPriLight, fontWeight: FontWeight.w800, fontSize: 32, letterSpacing: -0.5),
        titleLarge:    TextStyle(color: _textPriLight, fontWeight: FontWeight.w700, fontSize: 20),
        titleMedium:   TextStyle(color: _textPriLight, fontWeight: FontWeight.w600, fontSize: 16),
        titleSmall:    TextStyle(color: _textSecLight, fontWeight: FontWeight.w500, fontSize: 13),
        bodyLarge:     TextStyle(color: _textPriLight, fontSize: 16, height: 1.5),
        bodyMedium:    TextStyle(color: _textSecLight, fontSize: 14, height: 1.5),
        labelLarge:    TextStyle(color: Colors.white,  fontWeight: FontWeight.w600, fontSize: 15),
      ),
      dividerTheme: const DividerThemeData(color: _borderLight, space: 1, thickness: 1),
      listTileTheme: const ListTileThemeData(textColor: _textPriLight),
      switchTheme: SwitchThemeData(
        thumbColor: WidgetStateProperty.resolveWith((s) =>
            s.contains(WidgetState.selected) ? Colors.white : _textSecLight),
        trackColor: WidgetStateProperty.resolveWith((s) =>
            s.contains(WidgetState.selected)
                ? const Color(0xFF059669).withValues(alpha: 0.5)
                : _surfaceHighLight),
      ),
      extensions: [ct],
    );
  }

  // ── Helper ──────────────────────────────────────────────────────────────────
  static Color _darken(Color c, double amount) {
    final hsl = HSLColor.fromColor(c);
    return hsl.withLightness((hsl.lightness - amount).clamp(0.0, 1.0)).toColor();
  }
}
