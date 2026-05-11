import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'freemium_service.dart';
import 'analytics_service.dart';

/// Notifier for IAP errors — lets UI show a snackbar without BuildContext.
final iapErrorNotifier = ValueNotifier<String?>(null);

/// Shared IAP service — works for any one-time non-consumable premium product.
///
/// Usage:
/// ```dart
/// final iapService = CalcwiseIAP(
///   productId:  'premium_upgrade',
///   freemium:   freemiumService,
///   analytics:  analytics,
/// );
/// await iapService.initialize();
/// ```
class CalcwiseIAP {
  CalcwiseIAP({
    required this.productId,
    required this.freemium,
    required this.analytics,
    this.onPurchaseCompleted,
  });

  final String            productId;
  final CalcwiseFreemium  freemium;
  final CalcwiseAnalytics analytics;
  final VoidCallback?     onPurchaseCompleted;  // Optional hook for ReviewService, etc.

  StreamSubscription<List<PurchaseDetails>>? _sub;

  /// Localized price string from the Play Store (e.g. "$4.99").
  /// Null until the store responds — show a fallback in UI until set.
  final localizedPrice = ValueNotifier<String?>(null);

  // ── Lifecycle ─────────────────────────────────────────────────────────────

  Future<void> initialize() async {
    _sub = InAppPurchase.instance.purchaseStream.listen(_onPurchases);
    try {
      await InAppPurchase.instance.restorePurchases();
    } catch (e) {
      debugPrint('[IAP] restore error on init: $e');
    }
    _fetchPrice();
  }

  void dispose() => _sub?.cancel();

  // ── Public API ────────────────────────────────────────────────────────────

  /// Start the purchase flow.
  Future<void> buy() async {
    if (!await InAppPurchase.instance.isAvailable()) {
      iapErrorNotifier.value = 'Store not available. Check your connection.';
      return;
    }
    ProductDetailsResponse response;
    try {
      response = await InAppPurchase.instance
          .queryProductDetails({productId})
          .timeout(const Duration(seconds: 10));
    } on TimeoutException {
      iapErrorNotifier.value = 'Request timed out. Try again.';
      return;
    } catch (e) {
      iapErrorNotifier.value = 'Could not reach the store. Try again.';
      debugPrint('[IAP] query error: $e');
      return;
    }
    if (response.productDetails.isEmpty) {
      iapErrorNotifier.value = 'Product not found. Try again later.';
      debugPrint('[IAP] product "$productId" not found in Play Console');
      return;
    }
    await analytics.logPurchaseStarted();
    await InAppPurchase.instance.buyNonConsumable(
      purchaseParam: PurchaseParam(
          productDetails: response.productDetails.first),
    );
  }

  /// Restore a previous purchase (required by store policies).
  Future<void> restore() async {
    try {
      await InAppPurchase.instance.restorePurchases();
    } catch (e) {
      iapErrorNotifier.value = 'Restore failed. Try again later.';
      debugPrint('[IAP] restore error: $e');
    }
  }

  // ── Private ───────────────────────────────────────────────────────────────

  Future<void> _fetchPrice() async {
    try {
      final r = await InAppPurchase.instance
          .queryProductDetails({productId})
          .timeout(const Duration(seconds: 10));
      if (r.productDetails.isNotEmpty) {
        localizedPrice.value = r.productDetails.first.price;
      }
    } catch (e) {
      debugPrint('[IAP] price fetch error: $e');
    }
  }

  void _onPurchases(List<PurchaseDetails> purchases) {
    for (final p in purchases) {
      if (p.productID != productId) continue;

      switch (p.status) {
        case PurchaseStatus.purchased:
          freemium.activatePremium();
          analytics.logPurchaseCompleted();
          analytics.setUserPremium(true);
          onPurchaseCompleted?.call();
          debugPrint('[IAP] premium activated');

        case PurchaseStatus.restored:
          freemium.activatePremium();
          analytics.logPurchaseRestored();
          analytics.setUserPremium(true);
          onPurchaseCompleted?.call();
          debugPrint('[IAP] premium restored');

        case PurchaseStatus.error:
          analytics.logPurchaseFailed();
          debugPrint('[IAP] error: ${p.error}');

        default:
          break;
      }

      if (p.pendingCompletePurchase) {
        InAppPurchase.instance.completePurchase(p);
      }
    }
  }
}
