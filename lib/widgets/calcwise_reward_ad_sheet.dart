import 'dart:async';
import 'package:flutter/material.dart';
import '../services/freemium_service.dart';
import '../services/ad_service.dart';
import '../theme/calcwise_theme.dart';

/// Bottom sheet: watch a rewarded ad for 60-min ad-free access.
///
/// Configure once in main() before runApp():
/// ```dart
/// CalcwiseRewardAdSheet.configure(
///   adService: adService,
///   freemium:  freemiumService,
///   isSpanishNotifier: isSpanishNotifier,
/// );
/// ```
/// Then open with: `CalcwiseRewardAdSheet.show(context)`
class CalcwiseRewardAdSheet extends StatefulWidget {
  const CalcwiseRewardAdSheet({super.key});

  // ── Static configuration ────────────────────────────────────────────────

  static CalcwiseAdService?   _adService;
  static CalcwiseFreemium?    _freemium;
  static ValueNotifier<bool>? _isSpanish;

  static void configure({
    required CalcwiseAdService  adService,
    required CalcwiseFreemium   freemium,
    ValueNotifier<bool>?        isSpanishNotifier,
  }) {
    _adService = adService;
    _freemium  = freemium;
    _isSpanish = isSpanishNotifier;
  }

  static Future<void> show(BuildContext context) => showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
    ),
    builder: (_) => const CalcwiseRewardAdSheet(),
  );

  @override
  State<CalcwiseRewardAdSheet> createState() => _CalcwiseRewardAdSheetState();
}

class _CalcwiseRewardAdSheetState extends State<CalcwiseRewardAdSheet> {
  bool     _loading   = false;
  Timer?   _timer;
  Duration? _remaining;

  CalcwiseAdService get _ad => CalcwiseRewardAdSheet._adService!;
  CalcwiseFreemium  get _fr => CalcwiseRewardAdSheet._freemium!;
  bool get _isEs => CalcwiseRewardAdSheet._isSpanish?.value ?? false;

  @override
  void initState() {
    super.initState();
    _remaining = _fr.rewardedRemaining;
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (mounted) setState(() => _remaining = _fr.rewardedRemaining);
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  Future<void> _watch() async {
    setState(() => _loading = true);
    final earned = await _ad.showRewarded();
    if (!mounted) return;
    if (earned) {
      await _fr.activateRewarded();
      if (mounted) Navigator.of(context).pop();
    } else {
      setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final ct       = CalcwiseTheme.of(context);
    final adReady  = _ad.isRewardedReady;
    final isAdFree = _remaining != null && _remaining!.inSeconds > 0;

    return Container(
      decoration: BoxDecoration(
        color: ct.surfaceHigh,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
      ),
      padding: EdgeInsets.fromLTRB(
          24, 20, 24, 24 + MediaQuery.of(context).viewPadding.bottom),
      child: Column(mainAxisSize: MainAxisSize.min, children: [
        // Handle
        Container(width: 40, height: 4,
            decoration: BoxDecoration(
                color: ct.cardBorder,
                borderRadius: BorderRadius.circular(2))),
        const SizedBox(height: 20),

        // Shield icon
        Container(
          width: 64, height: 64,
          decoration: BoxDecoration(
            gradient: ct.ctaGradient,
            shape: BoxShape.circle,
          ),
          child: Icon(
            isAdFree ? Icons.shield : Icons.shield_rounded,
            color: Colors.white, size: 32,
          ),
        ),
        const SizedBox(height: 16),

        // Title
        Text(
          isAdFree
              ? (_isEs ? 'Sin anuncios activo' : 'Ad-Free Active')
              : (_isEs ? 'Ver anuncio — 60 min sin anuncios' : 'Watch ad — 60 min ad-free'),
          style: TextStyle(
              fontSize: 17, fontWeight: FontWeight.w700, color: ct.textPrimary),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 8),

        // Status chip / countdown
        if (isAdFree && _remaining != null)
          _StatusChip(
            label: _isEs
                ? 'Sin anuncios: ${_remaining!.inMinutes}m '
                  '${_remaining!.inSeconds.remainder(60)}s restantes'
                : 'Ad-free: ${_remaining!.inMinutes}m '
                  '${_remaining!.inSeconds.remainder(60)}s remaining',
            color: ct.successGreen,
          )
        else
          Text(
            _isEs
                ? 'Mira un anuncio corto para disfrutar 60 minutos sin publicidad.'
                : 'Watch a short ad to enjoy 60 minutes without ads.',
            style: TextStyle(fontSize: 13, color: ct.textSecondary, height: 1.4),
            textAlign: TextAlign.center,
          ),
        const SizedBox(height: 24),

        // Watch / Loading button
        if (!isAdFree)
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: (_loading || !adReady) ? null : _watch,
              icon: _loading
                  ? const SizedBox(width: 18, height: 18,
                      child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                  : const Icon(Icons.play_circle_outline),
              label: Text(_loading
                  ? (_isEs ? 'Cargando...' : 'Loading...')
                  : (_isEs ? 'Ver anuncio' : 'Watch Ad')),
              style: ElevatedButton.styleFrom(
                backgroundColor: ct.primary,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16)),
              ),
            ),
          ),

        if (!adReady && !isAdFree) ...[
          const SizedBox(height: 8),
          Text(
            _isEs ? 'Anuncio no disponible. Inténtalo más tarde.'
                  : 'Ad not available. Try again later.',
            style: TextStyle(fontSize: 11, color: ct.textSecondary),
            textAlign: TextAlign.center,
          ),
        ],

        const SizedBox(height: 8),
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text(_isEs ? 'Cerrar' : 'Close',
              style: TextStyle(color: ct.textSecondary, fontSize: 13)),
        ),
      ]),
    );
  }
}

class _StatusChip extends StatelessWidget {
  final String label;
  final Color  color;
  const _StatusChip({required this.label, required this.color});

  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
    decoration: BoxDecoration(
      color: color.withValues(alpha: 0.12),
      borderRadius: BorderRadius.circular(20),
      border: Border.all(color: color.withValues(alpha: 0.3)),
    ),
    child: Text(label,
        style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: color)),
  );
}
