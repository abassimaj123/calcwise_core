# Calcwise Core

Shared Firebase, AdMob, IAP and Freemium services for the Calcwise portfolio of financial calculator apps.

## Features

- **Freemium Service**: Manage free vs premium user tiers with calculation limits
- **IAP Service**: In-app purchase integration via Google Play Billing
- **Ad Service**: AdMob banner, interstitial, and rewarded ad management
- **Analytics Service**: Firebase Analytics event tracking
- **Paywall Session Service**: Track user paywall interactions and session counts
- **Theme Service**: Dark/light mode theme management
- **UI Widgets**: Pre-built paywall, splash screen, and insight card components

## Installation

Add to your `pubspec.yaml`:

```yaml
dependencies:
  calcwise_core: ^1.0.0
```

## Usage

Initialize in `main.dart`:

```dart
import 'package:calcwise_core/calcwise_core.dart';

void main() async {
  await freemiumService.initialize();
  await IAPService.instance.initialize();
  await AnalyticsService.instance.initialize();
  // ... other initialization
}
```

## License

MIT License - See LICENSE file for details.
