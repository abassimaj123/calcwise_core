/// Centralized monetization configuration for all Calcwise apps.
///
/// Apps can override individual values in their own freemium initialization:
/// ```dart
/// final freemium = CalcwiseFreemium(
///   appKey: 'mortgageus',
///   rewardedDurationMinutes: MonetizationConfig.rewardedDurationMinutes,
///   maxRewardedPerDay: MonetizationConfig.maxRewardedPerDay,
///   freeCalculationLimit: MonetizationConfig.freeCalculationLimit,
/// );
/// ```
class MonetizationConfig {
  MonetizationConfig._();

  /// Default duration for a rewarded ad session (minutes).
  /// User can watch one ad to unlock calculator for this duration.
  static const int rewardedDurationMinutes = 60;

  /// Maximum number of times per calendar day user can watch rewarded ads.
  /// 2 × 60 min = 2h free/day — generous enough to explore, limited enough to push IAP.
  static const int maxRewardedPerDay = 2;

  /// Free tier calculation limit before soft paywall appears.
  /// After reaching this many free calculations, user sees paywall on next attempt.
  static const int freeCalculationLimit = 5;

  /// IAP product ID for premium upgrade (must match Google Play Console).
  static const String premiumProductId = 'premium_upgrade';

  /// Free tier UI can show this many history items before paywall.
  static const int freeHistoryLimit = 5;

  /// Premium tier allows unlimited history.
  static const int premiumHistoryLimit = 999999;
}
