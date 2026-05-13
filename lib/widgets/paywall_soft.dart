import 'package:flutter/material.dart';
import '../theme/calcwise_theme.dart';

class PaywallSoft extends StatelessWidget {
  final String featureTitle, featureSubtitle;
  final bool isSpanish;
  final VoidCallback onUnlock;
  final VoidCallback? onMaybeLater; // null = no dismiss button shown
  const PaywallSoft({
    super.key, required this.featureTitle, required this.featureSubtitle,
    this.isSpanish = false, required this.onUnlock, this.onMaybeLater,
  });

  /// Show the soft paywall as a modal bottom sheet.
  /// "Maybe later" is always visible and dismissable — never aggressive.
  static Future<void> show(
    BuildContext context, {
    bool isSpanish = false,
    String? featureTitle,
    String? featureSubtitle,
    String? priceLabel,
    VoidCallback? onUnlock,
  }) async {
    await showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      isDismissible: true,
      builder: (ctx) => Padding(
        padding: EdgeInsets.fromLTRB(16, 16, 16, 16 + MediaQuery.of(ctx).viewPadding.bottom),
        child: PaywallSoft(
          isSpanish: isSpanish,
          featureTitle: featureTitle ??
              (isSpanish ? 'Función Premium' : 'Premium Feature'),
          featureSubtitle: featureSubtitle ??
              (isSpanish ? 'Desbloquea para continuar' : 'Unlock to continue'),
          onUnlock: () {
            Navigator.of(ctx).pop();
            onUnlock?.call();
          },
          onMaybeLater: () => Navigator.of(ctx).pop(),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final ct = CalcwiseTheme.of(context);
    final maybeLaterLabel = isSpanish ? 'Quizás luego' : 'Maybe later';

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: ct.surfaceHigh,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: ct.primary.withValues(alpha: 0.25)),
      ),
      child: Column(mainAxisSize: MainAxisSize.min, children: [
        Row(children: [
          Container(
            width: 40, height: 40,
            decoration: BoxDecoration(
                gradient: ct.ctaGradient,
                borderRadius: BorderRadius.circular(12)),
            child: const Icon(Icons.lock_outline, color: Colors.white, size: 20),
          ),
          const SizedBox(width: 12),
          Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(featureTitle,
                style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: ct.textPrimary)),
            const SizedBox(height: 2),
            Text(featureSubtitle,
                style: TextStyle(fontSize: 12, color: ct.textSecondary)),
          ])),
          const SizedBox(width: 8),
          GestureDetector(
            onTap: onUnlock,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
              decoration: BoxDecoration(
                gradient: ct.ctaGradient,
                borderRadius: BorderRadius.circular(10),
                boxShadow: [BoxShadow(
                  color: ct.primary.withValues(alpha: 0.35),
                  blurRadius: 10, offset: const Offset(0, 3))],
              ),
              child: Text(isSpanish ? 'Ver' : 'Unlock',
                  style: const TextStyle(color: Colors.white, fontSize: 12,
                      fontWeight: FontWeight.w700)),
            ),
          ),
        ]),
        if (onMaybeLater != null) ...[
          const SizedBox(height: 8),
          TextButton(
            onPressed: onMaybeLater,
            child: Text(maybeLaterLabel,
                style: TextStyle(fontSize: 12, color: ct.textSecondary)),
          ),
        ],
      ]),
    );
  }
}
