import 'dart:async';
import 'package:google_mobile_ads/google_mobile_ads.dart';

/// Request GDPR/CCPA/PIPEDA consent via Google UMP SDK.
///
/// Resolves on success, timeout, or error — the app always launches.
/// On non-EEA/UK devices the UMP SDK completes immediately.
///
/// Usage in main():
/// ```dart
/// await requestCalcwiseConsent();
/// await MobileAds.instance.initialize();
/// ```
Future<void> requestCalcwiseConsent() async {
  final completer = Completer<void>();
  ConsentInformation.instance.requestConsentInfoUpdate(
    ConsentRequestParameters(),
    () async {
      if (await ConsentInformation.instance.isConsentFormAvailable()) {
        ConsentForm.loadAndShowConsentFormIfRequired(
          (_) { if (!completer.isCompleted) completer.complete(); },
        );
      } else {
        if (!completer.isCompleted) completer.complete();
      }
    },
    (_) { if (!completer.isCompleted) completer.complete(); },
  );
  return completer.future;
}
