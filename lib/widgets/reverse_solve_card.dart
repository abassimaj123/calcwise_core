import 'package:flutter/material.dart';

import '../theme/tokens/tokens.dart';

/// Reusable "Reverse-Solve" card.
///
/// The classic "given target X, what input Y?" pattern, e.g.:
///   - Mortgage: "Given $2500/mo target, what home price can I afford?"
///   - AutoLoan: "Given $400/mo target, what vehicle price max?"
///   - RentBuy:  "Given $X budget, max home price?"
///   - PropertyROI: "Given 8% target CoC, max purchase price?"
///
/// Apps provide:
///   - a target value (e.g. monthly payment)
///   - a [compute] function that maps a candidate input to its output metric
///   - search [minBound] / [maxBound] and a [tolerance]
///
/// The widget runs a bounded binary search and renders input + result.
class ReverseSolveCard extends StatefulWidget {
  /// Card heading, e.g. "What home price can I afford?".
  final String title;

  /// Label above the input, e.g. "Target monthly payment".
  final String targetLabel;

  /// Label above the solved result, e.g. "Max home price".
  final String resultLabel;

  /// Optional input prefix, e.g. "$".
  final String? prefix;

  /// Optional input suffix, e.g. "%".
  final String? suffix;

  /// Lower bound for the search range.
  final double minBound;

  /// Upper bound for the search range.
  final double maxBound;

  /// Stop when the search interval is smaller than this. Default $1 precision.
  final double tolerance;

  /// Maps a candidate input value to the "output metric" the user is
  /// targeting (e.g. monthly payment for a candidate home price).
  final double Function(double candidate) compute;

  /// Initial target value (0 leaves the input empty).
  final double targetValue;

  /// `true` if [compute]'s output increases monotonically with the candidate
  /// (the typical cost-driven case). Set `false` when output decreases as the
  /// candidate increases (e.g. cap-rate vs purchase price).
  final bool ascending;

  /// Optional prefix for the result display. Defaults to [prefix].
  final String? resultPrefix;

  /// Optional suffix for the result display. Defaults to [suffix].
  final String? resultSuffix;

  const ReverseSolveCard({
    super.key,
    required this.title,
    required this.targetLabel,
    required this.resultLabel,
    required this.compute,
    required this.minBound,
    required this.maxBound,
    required this.targetValue,
    this.prefix,
    this.suffix,
    this.tolerance = 1.0,
    this.ascending = true,
    this.resultPrefix,
    this.resultSuffix,
  });

  @override
  State<ReverseSolveCard> createState() => _ReverseSolveCardState();
}

class _ReverseSolveCardState extends State<ReverseSolveCard> {
  late TextEditingController _ctrl;
  double? _solution;

  @override
  void initState() {
    super.initState();
    _ctrl = TextEditingController(
      text: widget.targetValue > 0 ? widget.targetValue.toStringAsFixed(0) : '',
    );
    if (widget.targetValue > 0) _solve();
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  void _solve() {
    final raw = _ctrl.text.replaceAll(',', '').trim();
    final target = double.tryParse(raw);
    if (target == null || target <= 0) {
      setState(() => _solution = null);
      return;
    }

    double lo = widget.minBound;
    double hi = widget.maxBound;
    int iter = 0;
    while (hi - lo > widget.tolerance && iter < 100) {
      final mid = (lo + hi) / 2;
      final v = widget.compute(mid);
      final overTarget = widget.ascending ? v > target : v < target;
      if (overTarget) {
        hi = mid;
      } else {
        lo = mid;
      }
      iter++;
    }

    setState(() => _solution = (lo + hi) / 2);
  }

  String _formatResult(double v) {
    final p = widget.resultPrefix ?? widget.prefix ?? '';
    final s = widget.resultSuffix ?? widget.suffix ?? '';
    // Group thousands, no decimals — matches headline KPI style.
    final whole = v.toStringAsFixed(0);
    final withCommas = whole.replaceAllMapped(
      RegExp(r'(\d)(?=(\d{3})+(?!\d))'),
      (m) => '${m[1]},',
    );
    return '$p$withCommas$s';
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppRadius.xl),
        side: BorderSide(color: Theme.of(context).dividerColor),
      ),
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(children: [
              Icon(Icons.swap_horiz_rounded,
                  color: scheme.primary, size: 22),
              const SizedBox(width: AppSpacing.sm),
              Expanded(
                child: Text(
                  widget.title,
                  style: const TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: AppTextSize.bodyMd,
                  ),
                ),
              ),
            ]),
            const SizedBox(height: AppSpacing.md),
            TextField(
              controller: _ctrl,
              keyboardType:
                  const TextInputType.numberWithOptions(decimal: true),
              decoration: InputDecoration(
                labelText: widget.targetLabel,
                prefixText: widget.prefix,
                suffixText: widget.suffix,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(AppRadius.lg),
                ),
                contentPadding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.lg, vertical: AppSpacing.mdPlus),
              ),
              onChanged: (_) => _solve(),
            ),
            const SizedBox(height: AppSpacing.lg),
            AnimatedSwitcher(
              duration: AppDuration.base,
              child: _solution == null
                  ? const SizedBox.shrink()
                  : Container(
                      key: ValueKey(_solution),
                      width: double.infinity,
                      padding: const EdgeInsets.all(AppSpacing.mdPlus),
                      decoration: BoxDecoration(
                        color: scheme.primary.withValues(alpha: 0.10),
                        borderRadius: BorderRadius.circular(AppRadius.lg),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            widget.resultLabel.toUpperCase(),
                            style: const TextStyle(
                              fontSize: AppTextSize.xs,
                              fontWeight: FontWeight.w600,
                              letterSpacing: 0.5,
                            ),
                          ),
                          const SizedBox(height: AppSpacing.xs),
                          Text(
                            _formatResult(_solution!),
                            style: TextStyle(
                              fontSize: AppTextSize.heroSm,
                              fontWeight: FontWeight.w800,
                              color: scheme.primary,
                              letterSpacing: -0.5,
                            ),
                          ),
                        ],
                      ),
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
