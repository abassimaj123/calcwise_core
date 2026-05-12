# calcwise_core — CHANGELOG

All notable changes to the shared `calcwise_core` library are documented here.  
Versions follow [Semantic Versioning](https://semver.org/).

---

## [1.1.0] — 2026-05-12

### Changed

- **`freemium_service.dart`** — `showAds` now gates on `hasFullAccess` instead of `isPremium`.  
  Rewarded-ad users who have earned temporary full access now also have ads hidden, consistent with the premium experience.

- **`freemium_service.dart`** — `historyLimit` now gates on `hasFullAccess` instead of `isPremium`.  
  Rewarded-ad users now receive the full (unlimited) calculation history, not the free-tier cap.

- **`freemium_service.dart`** — `initialize()` now runs a one-time migration that resets any persisted `ThemeMode.dark` value back to `ThemeMode.system`.  
  Migration key: `theme_mode_auto_default_v1` (written once; subsequent launches skip it).

- **`theme_mode_service.dart`** — Default `ThemeMode` changed from `ThemeMode.dark` to `ThemeMode.system`.  
  New installs and users who have never changed their theme preference now follow the OS setting automatically.

- **All 15 apps** — `calcwise_core` dependency source changed from `git:` (pinned hash) to `path: ../packages/calcwise_core`.  
  All apps now always resolve the local workspace version of the library, eliminating stale-hash drift between the library and consuming apps.

---

## [1.0.0] — 2026-05-11

### Added

Initial extraction of shared monetisation, analytics, and UI code from per-app implementations into a single reusable library.

**Services**
- `CalcwiseFreemium` — freemium gate logic (premium status, rewarded ads, history limit, ad visibility)
- `CalcwiseIAP` — in-app purchase integration (purchase flow, restore, entitlement callbacks)
- `CalcwiseAdService` — AdMob banner / interstitial / rewarded ad lifecycle management
- `CalcwiseAnalytics` — Firebase Analytics event wrappers (screen view, calculation, conversion events)
- `PaywallSessionService` — tracks session count and triggers soft / hard paywall at configured thresholds
- `ThemeModeService` — persisted theme preference (light / dark / system) via SharedPreferences

**Widgets**
- `PaywallSoft` — non-blocking upgrade prompt overlay (dismissible)
- `PaywallHard` — blocking paywall gate requiring upgrade or rewarded-ad unlock
- `InsightCard` — premium-gated insight display card with lock/unlock state
- `CalcwiseSplash` — branded animated splash screen shared across all apps
- `PageEntrance` — fade + slide entrance animation wrapper for top-level pages

**Theme**
- `CalcwiseTheme` — base `ThemeData` (light + dark) with shared typography and color scheme
- `ThemeFactory` — builds the correct `ThemeData` from a given `ThemeMode` and optional app-level overrides
- Design tokens — spacing, radius, elevation, and type-scale constants

**Config**
- `MonetizationConfig` — per-app configuration object (AdMob IDs, IAP SKUs, paywall thresholds, feature flags)
