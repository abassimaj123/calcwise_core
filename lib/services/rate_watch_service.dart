import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class RateWatchService {
  RateWatchService._();
  static final instance = RateWatchService._();

  static const _keyTarget  = 'rate_watch_target';
  static const _keyEnabled = 'rate_watch_enabled';
  static const _notifId    = 42;

  final _notif = FlutterLocalNotificationsPlugin();

  Future<void> init() async {
    const android = AndroidInitializationSettings('@mipmap/ic_launcher');
    const ios     = DarwinInitializationSettings();
    await _notif.initialize(const InitializationSettings(android: android, iOS: ios));
  }

  Future<double?> getTarget() async {
    final p = await SharedPreferences.getInstance();
    return p.getDouble(_keyTarget);
  }

  Future<bool> isEnabled() async {
    final p = await SharedPreferences.getInstance();
    return p.getBool(_keyEnabled) ?? false;
  }

  Future<void> setTarget(double rate, {required bool enabled}) async {
    final p = await SharedPreferences.getInstance();
    await p.setDouble(_keyTarget, rate);
    await p.setBool(_keyEnabled, enabled);
  }

  Future<void> disable() async {
    final p = await SharedPreferences.getInstance();
    await p.setBool(_keyEnabled, false);
  }

  /// Call this after each calculation — triggers notification if rate ≤ target.
  Future<void> checkRate(double currentRate, {required String appLabel}) async {
    if (!await isEnabled()) return;
    final target = await getTarget();
    if (target == null) return;
    if (currentRate > target) return;

    await _notif.show(
      _notifId,
      '🎉 Rate Alert — $appLabel',
      'Current rate ${currentRate.toStringAsFixed(2)}% is at or below your target of ${target.toStringAsFixed(2)}%!',
      const NotificationDetails(
        android: AndroidNotificationDetails(
          'rate_watch', 'Rate Watch Alerts',
          channelDescription: 'Alerts when mortgage rates hit your target',
          importance: Importance.high,
          priority: Priority.high,
        ),
      ),
    );
  }
}
