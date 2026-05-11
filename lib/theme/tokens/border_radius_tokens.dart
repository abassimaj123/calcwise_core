import 'package:flutter/painting.dart';

/// Calcwise border radius scale.
///
/// Usage:
///   borderRadius: BorderRadius.circular(AppRadius.md)
///   shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppRadius.lg))
class AppRadius {
  AppRadius._();

  /// 4px — subtle rounding (chips, tags)
  static const double xs = 4.0;

  /// 6px — small rounding
  static const double sm = 6.0;

  /// 8px — medium rounding (buttons, input fields)
  static const double md = 8.0;

  /// 12px — card rounding
  static const double lg = 12.0;

  /// 16px — sheet / dialog rounding
  static const double xl = 16.0;

  /// 24px — pill buttons
  static const double xxl = 24.0;

  /// 999px — full circle / pill
  static const double full = 999.0;

  // ── Pre-built BorderRadius constants ────────────────────────────────────

  static final card = BorderRadius.circular(lg);
  static final button = BorderRadius.circular(md);
  static final input = BorderRadius.circular(md);
  static final sheet = BorderRadius.circular(xl);
  static final chip = BorderRadius.circular(xs);
}
