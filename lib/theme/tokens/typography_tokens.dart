/// Calcwise typography scale.
///
/// Usage:
///   Text('label', style: TextStyle(fontSize: AppTextSize.sm))
///   TextStyle(fontWeight: AppFontWeight.semiBold)
class AppTextSize {
  AppTextSize._();

  /// 9px — micro label (chart axis)
  static const double xxs = 9.0;

  /// 11px — caption / tag
  static const double xs = 11.0;

  /// 12px — small label / hint
  static const double sm = 12.0;

  /// 13px — secondary body
  static const double md = 13.0;

  /// 14px — body text
  static const double body = 14.0;

  /// 15px — body medium
  static const double bodyMd = 15.0;

  /// 16px — default body (avoids iOS auto-zoom)
  static const double bodyLg = 16.0;

  /// 17px — body extra-large
  static const double bodyXl = 17.0;

  /// 18px — subtitle / section header
  static const double subtitle = 18.0;

  /// 19px — subtitle small step
  static const double subtitleSm = 19.0;

  /// 20px — title
  static const double title = 20.0;

  /// 22px — title medium
  static const double titleMd = 22.0;

  /// 24px — large title
  static const double titleLg = 24.0;

  /// 28px — display
  static const double display = 28.0;

  /// 32px — hero display
  static const double displayLg = 32.0;

  /// 32px — small hero display
  static const double heroSm = 32.0;

  /// 52px — KPI hero number
  static const double hero = 52.0;

  /// 72px — mega hero
  static const double heroXl = 72.0;
}

/// Font weight constants matching Material conventions.
class AppFontWeight {
  AppFontWeight._();

  /// Regular body text (400)
  static const regular = 400;

  /// Medium — labels, captions (500)
  static const medium = 500;

  /// Semi-bold — section headers (600)
  static const semiBold = 600;

  /// Bold — titles, emphasized values (700)
  static const bold = 700;
}
