import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

// ─────────────────────────────────────────────────────────────────────────────
// Persistence helpers
// ─────────────────────────────────────────────────────────────────────────────

/// Returns true if onboarding has been completed for [appKey].
/// Key is namespaced to avoid collisions between apps on the same device.
Future<bool> isOnboardingComplete(String appKey) async {
  final prefs = await SharedPreferences.getInstance();
  return prefs.getBool('${appKey}_onboarding_complete') ?? false;
}

/// Marks onboarding as done for [appKey].
Future<void> markOnboardingComplete(String appKey) async {
  final prefs = await SharedPreferences.getInstance();
  await prefs.setBool('${appKey}_onboarding_complete', true);
}

// ─────────────────────────────────────────────────────────────────────────────
// Data model
// ─────────────────────────────────────────────────────────────────────────────

/// Content for a single onboarding page.
///
/// Page renders:  [emoji container] → [title] → [subtitle]
///   then, if provided: [pills] or [bullets card] or [customWidget]
class OnboardingPage {
  /// Large emoji displayed in the coloured hero container (e.g. '🏠').
  final String emoji;

  /// Bold headline (≤ 6 words works best).
  final String title;

  /// Supporting sentence shown below the title.
  final String subtitle;

  /// Feature pill chips shown in a Wrap (page 1 style).
  /// Supply [pills] OR [bullets] OR [customWidget] — not multiple.
  final List<String>? pills;

  /// ✓ checklist items shown in a premium card (page 3 style).
  final List<String>? bullets;

  /// Fully custom widget rendered below the subtitle.
  final Widget? customWidget;

  /// Tint for the emoji container. Falls back to [ColorScheme.primary].
  final Color? containerColor;

  const OnboardingPage({
    required this.emoji,
    required this.title,
    required this.subtitle,
    this.pills,
    this.bullets,
    this.customWidget,
    this.containerColor,
  });
}

// ─────────────────────────────────────────────────────────────────────────────
// CalcwiseOnboarding widget
// ─────────────────────────────────────────────────────────────────────────────

/// Drop-in onboarding shell for all Calcwise apps.
///
/// Usage — inside the app's thin `onboarding_screen.dart`:
/// ```dart
/// class OnboardingScreen extends StatelessWidget {
///   final Widget nextScreen;
///   const OnboardingScreen({super.key, required this.nextScreen});
///
///   @override
///   Widget build(BuildContext context) => CalcwiseOnboarding(
///     appKey:     'mortgageus',
///     nextScreen: nextScreen,
///     pages: [
///       OnboardingPage(
///         emoji:    '🏠',
///         title:    'Your Smart\nMortgage Calculator',
///         subtitle: 'Monthly payment, amortization & more.',
///         pills:    ['51 States', '2025 Rates', 'Charts'],
///       ),
///       OnboardingPage(
///         emoji:    '📊',
///         title:    'Compare Scenarios',
///         subtitle: 'Switch loan types instantly and see the difference.',
///         containerColor: Colors.indigo,
///       ),
///       OnboardingPage(
///         emoji:    '⭐',
///         title:    'Go Premium',
///         subtitle: 'One purchase, unlimited access.',
///         bullets:  ['No ads', 'Unlimited history', 'Export to PDF'],
///       ),
///     ],
///   );
/// }
/// ```
class CalcwiseOnboarding extends StatefulWidget {
  /// Short lowercase app identifier — must match [CalcwiseFreemium.appKey].
  final String appKey;

  /// Pages of content (usually 3).
  final List<OnboardingPage> pages;

  /// Screen shown after onboarding completes / is skipped.
  final Widget nextScreen;

  /// Whether to show a "Skip" link on every page except the last.
  final bool showSkip;

  const CalcwiseOnboarding({
    super.key,
    required this.appKey,
    required this.pages,
    required this.nextScreen,
    this.showSkip = true,
  });

  @override
  State<CalcwiseOnboarding> createState() => _CalcwiseOnboardingState();
}

class _CalcwiseOnboardingState extends State<CalcwiseOnboarding> {
  final _ctrl = PageController();
  int _page = 0;

  int get _last => widget.pages.length - 1;

  void _next() {
    if (_page < _last) {
      _ctrl.nextPage(
          duration: const Duration(milliseconds: 350), curve: Curves.easeInOut);
    } else {
      _finish();
    }
  }

  void _back() {
    _ctrl.previousPage(
        duration: const Duration(milliseconds: 350), curve: Curves.easeInOut);
  }

  Future<void> _finish() async {
    await markOnboardingComplete(widget.appKey);
    if (!mounted) return;
    Navigator.of(context).pushReplacement(PageRouteBuilder(
      pageBuilder:        (_, __, ___) => widget.nextScreen,
      transitionsBuilder: (_, anim, __, child) =>
          FadeTransition(opacity: anim, child: child),
      transitionDuration:        const Duration(milliseconds: 250),
      reverseTransitionDuration: const Duration(milliseconds: 200),
    ));
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final isLast = _page == _last;

    return Scaffold(
      backgroundColor: cs.surface,
      body: SafeArea(
        child: Column(children: [
          // ── Top bar: dots + skip ──────────────────────────────────────────
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
            child: Row(children: [
              // Animated pill dots
              Row(
                mainAxisSize: MainAxisSize.min,
                children: List.generate(widget.pages.length, (i) {
                  return AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    margin: const EdgeInsets.symmetric(horizontal: 3),
                    width:  _page == i ? 22 : 8,
                    height: 8,
                    decoration: BoxDecoration(
                      color: _page == i
                          ? cs.primary
                          : cs.outlineVariant,
                      borderRadius: BorderRadius.circular(4),
                    ),
                  );
                }),
              ),
              const Spacer(),
              // Skip — hidden on last page
              if (widget.showSkip && !isLast)
                TextButton(
                  onPressed: _finish,
                  child: Text('Skip',
                      style: TextStyle(
                          color: cs.onSurfaceVariant,
                          fontWeight: FontWeight.w500)),
                ),
            ]),
          ),

          // ── Pages ─────────────────────────────────────────────────────────
          Expanded(
            child: PageView(
              controller: _ctrl,
              onPageChanged: (i) => setState(() => _page = i),
              children: widget.pages
                  .map((p) => _OnboardingPageView(page: p))
                  .toList(),
            ),
          ),

          // ── Navigation buttons ────────────────────────────────────────────
          Padding(
            padding: const EdgeInsets.fromLTRB(24, 0, 24, 32),
            child: Row(children: [
              if (_page > 0) ...[
                SizedBox(
                  height: 52,
                  child: OutlinedButton(
                    onPressed: _back,
                    style: OutlinedButton.styleFrom(
                      side: BorderSide(color: cs.outline),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16)),
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                    ),
                    child: Icon(Icons.arrow_back_rounded,
                        color: cs.onSurfaceVariant),
                  ),
                ),
                const SizedBox(width: 12),
              ],
              Expanded(
                child: SizedBox(
                  height: 52,
                  child: ElevatedButton(
                    onPressed: _next,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: cs.primary,
                      foregroundColor: cs.onPrimary,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16)),
                      elevation: 0,
                    ),
                    child: Text(
                      isLast ? 'Get Started' : 'Next',
                      style: const TextStyle(
                          fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ),
            ]),
          ),
        ]),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Single page layout
// ─────────────────────────────────────────────────────────────────────────────

class _OnboardingPageView extends StatelessWidget {
  final OnboardingPage page;
  const _OnboardingPageView({required this.page});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final containerColor = page.containerColor ?? cs.primary;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 32),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Hero emoji container
          Container(
            width: 120,
            height: 120,
            decoration: BoxDecoration(
              color: containerColor,
              borderRadius: BorderRadius.circular(32),
              boxShadow: [
                BoxShadow(
                  color: containerColor.withValues(alpha: 0.30),
                  blurRadius: 24,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: Center(
              child: Text(page.emoji,
                  style: const TextStyle(fontSize: 56)),
            ),
          ),

          const SizedBox(height: 36),

          // Title
          Text(
            page.title,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 26,
              fontWeight: FontWeight.bold,
              color: cs.onSurface,
              height: 1.25,
            ),
          ),

          const SizedBox(height: 14),

          // Subtitle
          Text(
            page.subtitle,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 15,
              color: cs.onSurfaceVariant,
              height: 1.55,
            ),
          ),

          const SizedBox(height: 28),

          // Pills
          if (page.pills != null && page.pills!.isNotEmpty)
            Wrap(
              spacing: 8,
              runSpacing: 8,
              alignment: WrapAlignment.center,
              children: page.pills!
                  .map((p) => _FeaturePill(label: p))
                  .toList(),
            ),

          // Premium bullets card
          if (page.bullets != null && page.bullets!.isNotEmpty)
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: cs.primaryContainer,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                    color: cs.primary.withValues(alpha: 0.35)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: page.bullets!
                    .expand((b) => [
                          _BulletRow(label: b, cs: cs),
                          if (b != page.bullets!.last)
                            const SizedBox(height: 12),
                        ])
                    .toList(),
              ),
            ),

          // Custom widget
          if (page.customWidget != null) page.customWidget!,
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Sub-widgets
// ─────────────────────────────────────────────────────────────────────────────

class _FeaturePill extends StatelessWidget {
  final String label;
  const _FeaturePill({required this.label});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      decoration: BoxDecoration(
        color: cs.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: cs.outlineVariant),
      ),
      child: Text(
        label,
        style: TextStyle(
            color: cs.onSurface,
            fontSize: 13,
            fontWeight: FontWeight.w500),
      ),
    );
  }
}

class _BulletRow extends StatelessWidget {
  final String label;
  final ColorScheme cs;
  const _BulletRow({required this.label, required this.cs});

  @override
  Widget build(BuildContext context) {
    return Row(children: [
      Icon(Icons.check_circle_rounded, color: cs.primary, size: 20),
      const SizedBox(width: 10),
      Expanded(
        child: Text(
          label,
          style: TextStyle(
            color: cs.onPrimaryContainer,
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    ]);
  }
}
