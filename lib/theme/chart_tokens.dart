/// Shared chart geometry tokens for Calcwise portfolio apps.
///
/// Used with fl_chart donut / pie charts across mortgage and loan calculators.
///
/// Usage:
/// ```dart
/// PieChartData(
///   centerSpaceRadius: CalcwiseChartTokens.donutCenterR,
///   sections: sections.map((s) => PieChartSectionData(
///     radius: CalcwiseChartTokens.donutSectionR,
///   )).toList(),
/// )
/// ```
class CalcwiseChartTokens {
  CalcwiseChartTokens._();

  // ── Donut chart ───────────────────────────────────────────────────────────

  /// Center space radius for standard mortgage/loan donut charts (55px).
  static const double donutCenterR  = 55.0;

  /// Section (ring) radius for standard mortgage/loan donut charts (20px).
  static const double donutSectionR = 20.0;

  /// Compact donut center radius for smaller charts, e.g. loan plan breakdowns (34px).
  static const double donutCenterRSm  = 34.0;

  // ── Typography (table scales used inside charts / schedule tables) ────────

  /// Body text size for data tables and schedule rows.
  static const double tableBodySize   = 12.0;

  /// Header text size for data tables and schedule column headers.
  static const double tableHeaderSize = 11.0;

  // ── Visual constants ──────────────────────────────────────────────────────

  /// Opacity applied to premium-locked chart segments.
  static const double lockedAlpha = 0.35;
}
