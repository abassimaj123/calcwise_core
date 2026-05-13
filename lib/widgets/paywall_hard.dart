import 'package:flutter/material.dart';
import '../theme/calcwise_theme.dart';

class PaywallHard extends StatelessWidget {
  final bool isSpanish;
  final VoidCallback onPurchase, onDismiss;
  final List<String>? features;
  final String? priceLabel;
  const PaywallHard({
    super.key, this.isSpanish = false,
    required this.onPurchase, required this.onDismiss,
    this.features, this.priceLabel,
  });

  @override
  Widget build(BuildContext context) {
    final ct  = CalcwiseTheme.of(context);
    final t   = isSpanish ? _es : _en;
    final fs  = features ?? _defaultFeatures(isSpanish);
    // priceLabel comes from iapService.localizedPrice — always pass it.
    // Fallback shows neutral text so no wrong price is ever shown.
    final cta = isSpanish
        ? 'Desbloquear Premium${priceLabel != null ? ' — $priceLabel' : ''}'
        : 'Unlock Premium${priceLabel != null ? ' — $priceLabel' : ''}';

    return Container(
      decoration: BoxDecoration(
        color: ct.surface,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
      ),
      padding: EdgeInsets.fromLTRB(24, 12, 24, 32 + MediaQuery.of(context).viewPadding.bottom),
      child: Column(mainAxisSize: MainAxisSize.min, children: [
        Container(width: 40, height: 4,
            decoration: BoxDecoration(color: ct.cardBorder,
                borderRadius: BorderRadius.circular(2))),
        const SizedBox(height: 24),
        Container(
          width: 72, height: 72,
          decoration: BoxDecoration(gradient: ct.ctaGradient,
              borderRadius: BorderRadius.circular(20)),
          child: const Icon(Icons.workspace_premium_rounded,
              color: Colors.white, size: 36),
        ),
        const SizedBox(height: 20),
        Text(t['title']!,
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.w800,
                color: ct.textPrimary),
            textAlign: TextAlign.center),
        const SizedBox(height: 8),
        Text(t['subtitle']!,
            style: TextStyle(fontSize: 14, color: ct.textSecondary, height: 1.5),
            textAlign: TextAlign.center),
        const SizedBox(height: 28),
        ...fs.map((f) => _FeatureRow(f, ct)),
        const SizedBox(height: 28),
        SizedBox(
          width: double.infinity,
          child: Container(
            decoration: BoxDecoration(
              gradient: ct.ctaGradient,
              borderRadius: BorderRadius.circular(14),
              boxShadow: [BoxShadow(color: ct.primary.withValues(alpha: 0.4),
                  blurRadius: 16, offset: const Offset(0, 4))],
            ),
            child: ElevatedButton(
              onPressed: onPurchase,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.transparent, shadowColor: Colors.transparent,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14)),
              ),
              child: Text(cta, style: const TextStyle(color: Colors.white,
                  fontSize: 16, fontWeight: FontWeight.w700)),
            ),
          ),
        ),
        const SizedBox(height: 12),
        TextButton(onPressed: onDismiss,
            child: Text(t['dismiss']!,
                style: TextStyle(color: ct.textSecondary, fontSize: 13))),
      ]),
    );
  }

  /// Show the hard paywall as a modal bottom sheet.
  static Future<void> show(
    BuildContext context, {
    bool isSpanish = false,
    List<String>? features,
    String? priceLabel,
    String? savingsLabel,
    VoidCallback? onPurchase,
  }) async {
    await showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      isDismissible: false,
      enableDrag: false,
      builder: (_) => PaywallHard(
        isSpanish: isSpanish,
        features: features,
        priceLabel: priceLabel,
        onPurchase: () {
          Navigator.of(context).pop();
          onPurchase?.call();
        },
        onDismiss: () => Navigator.of(context).pop(),
      ),
    );
  }

  static List<String> _defaultFeatures(bool es) => es
      ? ['📊  Análisis detallado', '📈  Proyecciones', '📄  Exportar PDF',
         '🔄  Uso ilimitado',      '🚫  Sin anuncios']
      : ['📊  Detailed analysis',  '📈  Projections', '📄  PDF export',
         '🔄  Unlimited use',      '🚫  No ads'];

  static const _en = {'title':'Unlock Full Analysis',
    'subtitle':'Get the complete picture with all premium features.','dismiss':'Not now'};
  static const _es = {'title':'Desbloquear análisis completo',
    'subtitle':'Obtén el panorama completo con todas las funciones premium.','dismiss':'Ahora no'};
}

class _FeatureRow extends StatelessWidget {
  final String text; final CalcwiseTheme ct;
  const _FeatureRow(this.text, this.ct);
  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.symmetric(vertical: 5),
    child: Row(children: [
      Icon(Icons.check_circle, color: ct.successGreen, size: 18),
      const SizedBox(width: 12),
      Expanded(child: Text(text,
          style: TextStyle(fontSize: 14, color: ct.textPrimary))),
    ]),
  );
}
