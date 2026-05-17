import 'package:flutter/material.dart';

class ComparisonScenario {
  final String label;
  final Color? accentColor;
  final Map<String, String> metrics; // metric label -> formatted value
  ComparisonScenario({
    required this.label,
    this.accentColor,
    required this.metrics,
  });
}

/// Side-by-side comparison of 2-3 scenarios.
/// Renders a header row with scenario labels + a row per metric with values aligned.
class ComparisonView extends StatelessWidget {
  final List<ComparisonScenario> scenarios;
  final String? title;
  final List<String>? metricOrder; // optional: explicit order of metric keys; otherwise insertion order of first scenario
  final int? winnerIndex; // optional: highlight winning scenario column

  const ComparisonView({
    super.key,
    required this.scenarios,
    this.title,
    this.metricOrder,
    this.winnerIndex,
  }) : assert(scenarios.length >= 2 && scenarios.length <= 3, 'Comparison requires 2 or 3 scenarios');

  @override
  Widget build(BuildContext context) {
    final keys = metricOrder ?? scenarios.first.metrics.keys.toList();
    final theme = Theme.of(context);

    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: theme.dividerColor),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (title != null) ...[
              Text(title!, style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 15)),
              const SizedBox(height: 12),
            ],
            // Header row: scenario labels
            Row(children: [
              const Expanded(flex: 2, child: SizedBox()),
              for (var i = 0; i < scenarios.length; i++)
                Expanded(
                  flex: 3,
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
                    decoration: BoxDecoration(
                      color: winnerIndex == i
                        ? (scenarios[i].accentColor ?? theme.colorScheme.primary).withValues(alpha: 0.1)
                        : null,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          scenarios[i].label,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontWeight: FontWeight.w700,
                            fontSize: 13,
                            color: scenarios[i].accentColor ?? theme.colorScheme.primary,
                          ),
                        ),
                        if (winnerIndex == i)
                          Padding(
                            padding: const EdgeInsets.only(top: 2),
                            child: Icon(Icons.emoji_events_rounded, size: 14, color: scenarios[i].accentColor ?? theme.colorScheme.primary),
                          ),
                      ],
                    ),
                  ),
                ),
            ]),
            const Divider(height: 20),
            // Rows: metric values
            for (final key in keys) Padding(
              padding: const EdgeInsets.symmetric(vertical: 6),
              child: Row(children: [
                Expanded(flex: 2, child: Text(key, style: TextStyle(fontSize: 12, color: theme.colorScheme.onSurface.withValues(alpha: 0.7)))),
                for (final s in scenarios)
                  Expanded(
                    flex: 3,
                    child: Text(
                      s.metrics[key] ?? '—',
                      textAlign: TextAlign.center,
                      style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
                    ),
                  ),
              ]),
            ),
          ],
        ),
      ),
    );
  }
}
