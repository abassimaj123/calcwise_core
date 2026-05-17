import 'package:flutter/material.dart';
import '../models/insight.dart';
import '../theme/calcwise_theme.dart';
import '../theme/tokens/tokens.dart';

class InsightCard extends StatelessWidget {
  final List<Insight> insights;
  final bool isSpanish;
  const InsightCard({super.key, required this.insights, this.isSpanish = false});

  @override
  Widget build(BuildContext context) {
    if (insights.isEmpty) return const SizedBox.shrink();
    final ct = CalcwiseTheme.of(context);
    return Container(
      decoration: BoxDecoration(
        color: ct.surface,
        borderRadius: BorderRadius.circular(AppRadius.xl),
        border: Border.all(color: ct.cardBorder),
      ),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(AppSpacing.lg, AppSpacing.mdPlus, AppSpacing.lg, AppSpacing.smPlus),
          child: Row(children: [
            Icon(Icons.lightbulb_outline_rounded, size: 18, color: ct.accent),
            const SizedBox(width: AppSpacing.sm),
            Text(isSpanish ? 'Análisis inteligente' : 'Smart Insights',
                style: TextStyle(fontSize: AppTextSize.body, fontWeight: FontWeight.w700,
                    color: ct.textPrimary)),
          ]),
        ),
        Divider(height: 1, color: ct.cardBorder),
        ...insights.map((i) => _InsightTile(i, ct)),
        const SizedBox(height: AppSpacing.xs),
      ]),
    );
  }
}

class _InsightTile extends StatelessWidget {
  final Insight i; final CalcwiseTheme ct;
  const _InsightTile(this.i, this.ct);
  @override
  Widget build(BuildContext context) {
    final color = switch (i.severity) {
      InsightSeverity.good    => ct.successGreen,
      InsightSeverity.warning => ct.accent,
      InsightSeverity.alert   => ct.errorRed,
    };
    return Container(
      margin: const EdgeInsets.fromLTRB(AppSpacing.md, 6, AppSpacing.md, 0),
      padding: const EdgeInsets.fromLTRB(AppSpacing.md, AppSpacing.smPlus, AppSpacing.smPlus, AppSpacing.smPlus),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.07),
        borderRadius: BorderRadius.circular(AppRadius.lg),
        border: Border(left: BorderSide(color: color, width: 3)),
      ),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(i.title, style: TextStyle(fontSize: AppTextSize.md,
            fontWeight: FontWeight.w600, color: color)),
        const SizedBox(height: 3),
        Text(i.body, style: TextStyle(fontSize: AppTextSize.md,
            color: ct.textSecondary, height: 1.4)),
      ]),
    );
  }
}
