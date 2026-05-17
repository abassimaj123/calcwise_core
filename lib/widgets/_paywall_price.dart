import 'package:flutter/foundation.dart' show ValueNotifier;

/// Shared global price notifier for all paywall widgets.
/// Set once via PaywallHard.registerPrice() in IAPService.initialize().
final globalPaywallPrice = ValueNotifier<String?>(null);
