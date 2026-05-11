import 'package:flutter/material.dart';

enum InsightSeverity { good, warning, alert }

class Insight {
  final String title;
  final String body;
  final InsightSeverity severity;
  final IconData? icon;
  const Insight({required this.title, required this.body, required this.severity, this.icon});
}
