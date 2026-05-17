# calcwise_core

Shared Flutter package for the CalcWise portfolio (22 apps). Single source of truth for theme, monetization, design tokens, and shared widgets.

## Design Tokens

### Spacing (`AppSpacing`)
- xs=4, sm=8, smPlus=10, md=12, mdPlus=14, lg=16, xl=24, xxl=24, xxlPlus=28, xxxl=32
- Use: `EdgeInsets.all(AppSpacing.lg)` not `EdgeInsets.all(16)`

### Typography (`AppTextSize`)
- 11 sizes: tiny=11, caption=12, bodySm=13, body=14, bodyMd=15, bodyLg=16, bodyXl=17, subtitle=18, subtitleSm=19, title=20, titleMd=22, titleLg=24
- Display: heroSm=32, hero=52, heroXl=72
- Use: `TextStyle(fontSize: AppTextSize.hero)` not `fontSize: 52`

### Border Radius (`AppRadius`)
- xs=4, sm=8, md=8, mdPlus=10, lg=12, xl=16, xxl=24
- Use: `BorderRadius.circular(AppRadius.lg)` not `BorderRadius.circular(16)`

### Motion (`AppDuration`, `AppCurves`)
- Durations: fast=150ms, base=250ms, page=300ms, slow=400ms
- Curves: standard=easeOutCubic, emphasized=easeOutQuart, linear

### Semantic Colors (via `CalcwiseTheme.of(context)`)
- `successGreen`, `successGreenSoft`
- `warningOrange`, `warningOrangeSoft`
- `errorRed`, `errorRedSoft`

## Shared Widgets

| Widget | Purpose |
|--------|---------|
| `CalcwiseHeroCard` | 52px hero number for primary result |
| `CalcwiseSettingsScaffold` | Standard settings layout |
| `CalcwiseAdFooter` | Bottom banner ad (configure once in main.dart) |
| `CalcwiseEmptyState` | Empty state with icon + CTA |
| `CalcwisePageEntrance` | Page enter animation wrapper |
| `PaywallSoft` / `PaywallHard` | Premium upsell modals |
| `ReverseSolveCard` | "Given target X, what input Y?" widget |
| `ComparisonView` | Side-by-side 2-3 scenarios |
| `InsightCard` | Tiered info/warn/alert/success banners |
| `SectionCard` | Standard content card with title |

## Theming

Configure in `main.dart`:
```dart
CalcwiseAdFooter.configure(adService, freemium, isSpanishNotifier, onGetPremium);

MaterialApp(
  theme: CalcwiseThemeFactory.buildLight(
    primary: const Color(0xFF0D47A1),
    accent: const Color(0xFFF59E0B),
  ),
  darkTheme: CalcwiseThemeFactory.buildDark(
    primary: const Color(0xFF0D47A1),
    accent: const Color(0xFFF59E0B),
  ),
)
```

Dark mode automatically derives a brand-tinted dark surface from the primary color.

## Monetization

| Service | Purpose |
|---------|---------|
| `FreemiumService` | Premium status, free-tier limits |
| `IAPService` | One-time `$2.99` purchase + restore |
| `AdService` | Banner + interstitial + rewarded ads |
| `PaywallSessionService` | Track soft-paywall triggers per session |
| `AnalyticsService` | Calculation/PDF/save events |

## Conventions

- **No magic numbers**: every paddings/font/radius/duration goes through a token
- **Never hardcode colors**: always use `Theme.of(context).colorScheme` or `CalcwiseTheme.of(context)`
- **Icons**: prefer `_rounded` variants for visual coherence
- **Animations**: `AnimatedSwitcher` with `AppDuration.base` for result changes
- **Form fields**: use `InputDecoration` from the shared theme (auto-applies focused border, padding)
