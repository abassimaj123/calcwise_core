# calcwise_core — iOS Templates

This folder contains **opt-in** templates for activating iOS support on any portfolio app.
Nothing in this folder is loaded, imported, or built unless you explicitly run `activate_ios.sh`
against a target app.

## Why this exists

The 15 Flutter apps in the portfolio ship as **Android-only** today. iOS support
is planned but not active. To prevent iOS work from accidentally breaking Android
builds (or forcing a re-test cycle), all iOS-specific assets live here, isolated
from `lib/`, `android/`, and `pubspec.yaml`.

## Contents

| File | Purpose |
|------|---------|
| `AppDelegate.swift.template`     | Replacement for `ios/Runner/AppDelegate.swift` — adds Firebase init + MobileAds + ATT request. |
| `Info.plist.additions.xml`       | Snippets to **merge** into `ios/Runner/Info.plist` (GADApplicationIdentifier, NSUserTrackingUsageDescription, SKAdNetworkItems). |
| `SKAdNetworkItems.plist`         | Canonical list of SKAdNetwork IDs (AdMob + major mediation partners). |
| `PrivacyInfo.xcprivacy.template` | Privacy manifest required by Apple for iOS 17+. |
| `activate_ios.sh`                | Idempotent shell script that copies these templates into a target app. Dry-run by default. |
| `IOS_MIGRATION_GUIDE.md`         | Full migration guide: what changes, what stays, what to test. |

## Quick start

```bash
# Dry-run (default) — shows what would change, modifies nothing
bash D:/mob/packages/calcwise_core/ios_templates/activate_ios.sh MortgageUS

# Actually apply (only after dry-run looks correct)
bash D:/mob/packages/calcwise_core/ios_templates/activate_ios.sh MortgageUS --apply
```

The script will:

1. Verify the target app has an `ios/Runner/` directory.
2. Copy templates into `ios/Runner/` with `{{BUNDLE_ID}}`, `{{ADMOB_APP_ID}}`, `{{APP_NAME}}` substituted.
3. Print a TODO checklist (Firebase iOS app, GoogleService-Info.plist, Apple Developer membership, etc.).

The script will **never** touch `android/`, `lib/`, `pubspec.yaml`, or any file
outside the target's `ios/Runner/` directory.

## What activation does NOT do

- Does not modify Dart code in `lib/`
- Does not modify `android/`
- Does not change `pubspec.yaml`
- Does not run `flutter pub get` or any build
- Does not add iOS-only Dart packages (you must do that manually if needed)

## Android-only mode is the default

Until `activate_ios.sh --apply` is run for a given app, that app continues to
build and ship Android exactly as before. Zero risk of regression.
