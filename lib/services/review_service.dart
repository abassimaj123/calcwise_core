import 'package:flutter/foundation.dart';
import 'package:in_app_review/in_app_review.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Shared in-app review service for the Calcwise portfolio.
///
/// Strategy:
///   - After Nth save  → user has seen real value
///   - After premium purchase → guaranteed happy user
///   - At most once per 90 days to avoid spamming (Google/Apple policy)
class CalcwiseReviewService {
  CalcwiseReviewService._();
  static final instance = CalcwiseReviewService._();

  static const _keyLastShown  = 'review_last_ms';
  static const _keySaveCount  = 'review_save_count';
  static const int saveThreshold  = 3;
  static const int minDaysBetween = 90;

  /// Call every time the user saves a calculation.
  /// Shows review dialog after [saveThreshold] saves, then at most once
  /// every [minDaysBetween] days.
  Future<void> requestAfterSave() async {
    final prefs = await SharedPreferences.getInstance();
    final count = (prefs.getInt(_keySaveCount) ?? 0) + 1;
    await prefs.setInt(_keySaveCount, count);
    if (count >= saveThreshold) await _maybeRequest(prefs);
  }

  /// Call immediately after a successful premium purchase.
  Future<void> requestAfterPremium() async {
    final prefs = await SharedPreferences.getInstance();
    await _maybeRequest(prefs);
  }

  /// Alias for [requestAfterPremium] — used by some apps as requestAfterPurchase.
  Future<void> requestAfterPurchase() => requestAfterPremium();

  /// Alias for [requestAfterPremium] — used by some apps as requestReview.
  Future<void> requestReview() => requestAfterPremium();

  /// Opens the store listing directly (used in Settings "Rate App" row).
  Future<void> openStoreListing() async {
    try {
      await InAppReview.instance.openStoreListing();
    } catch (e) {
      debugPrint('[ReviewService] openStoreListing error: $e');
    }
  }

  /// Alias for [openStoreListing].
  Future<void> openStoreForReview() => openStoreListing();

  Future<void> _maybeRequest(SharedPreferences prefs) async {
    final lastMs = prefs.getInt(_keyLastShown) ?? 0;
    final daysSinceLast = DateTime.now()
        .difference(DateTime.fromMillisecondsSinceEpoch(lastMs))
        .inDays;
    if (lastMs > 0 && daysSinceLast < minDaysBetween) return;

    try {
      final review = InAppReview.instance;
      if (!await review.isAvailable()) return;
      await review.requestReview();
      await prefs.setInt(_keyLastShown, DateTime.now().millisecondsSinceEpoch);
      await prefs.setInt(_keySaveCount, 0);
    } catch (e) {
      debugPrint('[ReviewService] requestReview error: $e');
    }
  }
}
