import 'package:flutter/material.dart';

/// Show the "Welcome to Premium" confirmation snackbar.
///
/// Call from `_onPremiumChange()` when `now && !_wasPremium`.
/// ```dart
/// void _onPremiumChange() {
///   final now = freemiumService.hasFullAccess;
///   if (now && !_wasPremium && mounted) {
///     showPremiumWelcomeSnackBar(context, isSpanish: isSpanishNotifier.value);
///   }
///   _wasPremium = now;
/// }
/// ```
void showPremiumWelcomeSnackBar(
  BuildContext context, {
  bool isSpanish = false,
}) {
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
    content: Row(children: [
      const Icon(Icons.verified_rounded, color: Color(0xFFF59E0B), size: 20),
      const SizedBox(width: 10),
      Text(
        isSpanish ? '¡Bienvenido a Premium! Gracias.' : 'Welcome to Premium! Thank you.',
        style: const TextStyle(fontWeight: FontWeight.w600),
      ),
    ]),
    backgroundColor: Theme.of(context).colorScheme.primary,
    duration: const Duration(seconds: 4),
    behavior: SnackBarBehavior.floating,
  ));
}

/// Show an IAP error snackbar (called from `iapErrorNotifier` listener).
///
/// ```dart
/// void _onIapError() {
///   final msg = iapErrorNotifier.value;
///   if (msg == null || !mounted) return;
///   showIapErrorSnackBar(context, msg);
///   iapErrorNotifier.value = null;
/// }
/// ```
void showIapErrorSnackBar(BuildContext context, String message) {
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
    content: Text(message, style: const TextStyle(fontWeight: FontWeight.w600)),
    backgroundColor: Colors.red.shade700,
    duration: const Duration(seconds: 4),
    behavior: SnackBarBehavior.floating,
  ));
}
