import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:calcwise_core/calcwise_core.dart';

void main() {
  // Helper to build a fresh instance with mock prefs
  CalcwiseFreemium build({
    int freeLimit = 5,
    int maxRewarded = 3,
    int rewardedMinutes = 60,
  }) =>
      CalcwiseFreemium(
        appKey: 'test',
        freeCalculationLimit: freeLimit,
        maxRewardedPerDay: maxRewarded,
        rewardedDurationMinutes: rewardedMinutes,
      );

  setUp(() {
    SharedPreferences.setMockInitialValues({});
  });

  // ── 1. isPremium is false by default ──────────────────────────────────────
  test('1. isPremium is false by default', () async {
    final f = build();
    await f.initialize();
    expect(f.isPremium, isFalse);
  });

  // ── 2. activatePremium sets isPremium to true and persists ────────────────
  test('2. activatePremium() sets isPremium true and persists', () async {
    final f = build();
    await f.initialize();
    await f.activatePremium();
    expect(f.isPremium, isTrue);

    // Simulate restart — new instance, same mock prefs
    final f2 = build();
    await f2.initialize();
    expect(f2.isPremium, isTrue);
  });

  // ── 3. hasFullAccess = isPremium || isRewarded ────────────────────────────
  test('3. hasFullAccess is true when premium', () async {
    final f = build();
    await f.initialize();
    expect(f.hasFullAccess, isFalse);
    await f.activatePremium();
    expect(f.hasFullAccess, isTrue);
  });

  test('3b. hasFullAccess is true when rewarded', () async {
    final f = build();
    await f.initialize();
    expect(f.hasFullAccess, isFalse);
    await f.activateRewarded();
    expect(f.hasFullAccess, isTrue);
  });

  // ── 4. showAds = !hasFullAccess ───────────────────────────────────────────
  test('4. showAds is true when free', () async {
    final f = build();
    await f.initialize();
    expect(f.showAds, isTrue);
  });

  test('4b. showAds is false when premium', () async {
    final f = build();
    await f.initialize();
    await f.activatePremium();
    expect(f.showAds, isFalse);
  });

  // ── 5. canWatchRewarded returns false when already premium ────────────────
  test('5. canWatchRewarded() is false when premium', () async {
    final f = build();
    await f.initialize();
    await f.activatePremium();
    expect(f.canWatchRewarded(), isFalse);
  });

  // ── 6. canWatchRewarded returns true for free user under daily limit ──────
  test('6. canWatchRewarded() is true for free user below daily limit', () async {
    final f = build(maxRewarded: 3);
    await f.initialize();
    expect(f.canWatchRewarded(), isTrue);
  });

  // ── 7. canWatchRewarded returns false when daily limit reached ────────────
  test('7. canWatchRewarded() is false when daily limit reached', () async {
    final f = build(maxRewarded: 1, rewardedMinutes: -1);
    await f.initialize();
    // First watch — uses limit of 1
    await f.activateRewarded();
    // Force rewarded to expire so canWatchRewarded doesn't bail on isRewarded
    SharedPreferences.setMockInitialValues({
      'test_rewarded_exp':
          DateTime.now().subtract(const Duration(minutes: 5)).toIso8601String(),
      'test_rewarded_day':
          () {
            final n = DateTime.now();
            return n.year * 10000 + n.month * 100 + n.day;
          }(),
      'test_rewarded_count': 1,
    });
    final f2 = build(maxRewarded: 1);
    await f2.initialize();
    expect(f2.canWatchRewarded(), isFalse);
  });

  // ── 8. activateRewarded sets isRewarded to true ───────────────────────────
  test('8. activateRewarded() sets isRewarded true', () async {
    final f = build();
    await f.initialize();
    expect(f.isRewarded, isFalse);
    await f.activateRewarded();
    expect(f.isRewarded, isTrue);
  });

  // ── 9. rewardedRemaining returns non-null duration when active ────────────
  test('9. rewardedRemaining is non-null after activateRewarded()', () async {
    final f = build(rewardedMinutes: 60);
    await f.initialize();
    await f.activateRewarded();
    final rem = f.rewardedRemaining;
    expect(rem, isNotNull);
    expect(rem!.inMinutes, greaterThan(58));
  });

  // ── 10. historyLimit = 999999 when hasFullAccess, freeLimit otherwise ─────
  test('10. historyLimit is 999999 when premium', () async {
    final f = build(freeLimit: 5);
    await f.initialize();
    expect(f.historyLimit, equals(5));
    await f.activatePremium();
    expect(f.historyLimit, equals(999999));
  });

  // ── 11. showSoftGate false when hasFullAccess regardless of calcCount ──────
  test('11. showSoftGate is false when premium regardless of calcCount', () async {
    final f = build(freeLimit: 2);
    await f.initialize();
    await f.activatePremium();
    await f.incrementCalcCount();
    await f.incrementCalcCount();
    await f.incrementCalcCount();
    expect(f.showSoftGate, isFalse);
  });

  // ── 12. showSoftGate true when free + calcCount >= freeLimit ──────────────
  test('12. showSoftGate is true when free and calcCount >= freeLimit', () async {
    final f = build(freeLimit: 3);
    await f.initialize();
    expect(f.showSoftGate, isFalse);
    await f.incrementCalcCount(); // 1
    await f.incrementCalcCount(); // 2
    expect(f.showSoftGate, isFalse);
    await f.incrementCalcCount(); // 3 — hits limit
    expect(f.showSoftGate, isTrue);
  });

  // ── 13. incrementCalcCount increments correctly ───────────────────────────
  test('13. incrementCalcCount() increments by 1 each call', () async {
    final f = build();
    await f.initialize();
    expect(f.calcCount, equals(0));
    final c1 = await f.incrementCalcCount();
    expect(c1, equals(1));
    expect(f.calcCount, equals(1));
    final c2 = await f.incrementCalcCount();
    expect(c2, equals(2));
    expect(f.calcCount, equals(2));
  });

  // ── 14. resetCalcCount resets to 0 ───────────────────────────────────────
  test('14. resetCalcCount() resets calcCount to 0', () async {
    final f = build();
    await f.initialize();
    await f.incrementCalcCount();
    await f.incrementCalcCount();
    expect(f.calcCount, equals(2));
    await f.resetCalcCount();
    expect(f.calcCount, equals(0));
  });
}
