import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/foundation.dart';

/// One-line Crashlytics init — identical across all apps.
/// Call once in main() after Firebase.initializeApp().
///
/// ```dart
/// await Firebase.initializeApp();
/// await CrashlyticsService.init();
/// ```
class CrashlyticsService {
  CrashlyticsService._();

  static Future<void> init() async {
    FlutterError.onError =
        FirebaseCrashlytics.instance.recordFlutterFatalError;
    PlatformDispatcher.instance.onError = (error, stack) {
      FirebaseCrashlytics.instance.recordError(error, stack, fatal: true);
      return true;
    };
  }
}
