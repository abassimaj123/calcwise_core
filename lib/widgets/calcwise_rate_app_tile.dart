import 'package:flutter/material.dart';
import '../services/review_service.dart';
import '../theme/calcwise_theme.dart';

/// Settings list tile that opens the store listing for app rating.
///
/// Drop-in replacement for any custom "Rate App" row in Settings screens.
///
/// Usage:
/// ```dart
/// // In your Settings ListView/Column:
/// const CalcwiseRateAppTile(),
///
/// // With custom label (e.g. French):
/// CalcwiseRateAppTile(label: 'Évaluer l\'app'),
/// ```
class CalcwiseRateAppTile extends StatelessWidget {
  final String? label;
  final String? sublabel;

  const CalcwiseRateAppTile({super.key, this.label, this.sublabel});

  @override
  Widget build(BuildContext context) {
    final ct = CalcwiseTheme.of(context);
    return ListTile(
      leading: Icon(Icons.star_outline_rounded,
          color: Theme.of(context).colorScheme.primary),
      title: Text(
        label ?? 'Rate the App',
        style: TextStyle(color: ct.textPrimary, fontWeight: FontWeight.w500),
      ),
      subtitle: sublabel != null
          ? Text(sublabel!, style: TextStyle(color: ct.textSecondary, fontSize: 12))
          : null,
      trailing: Icon(Icons.chevron_right, color: ct.textSecondary),
      onTap: () => CalcwiseReviewService.instance.openStoreListing(),
    );
  }
}
