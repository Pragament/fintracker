import 'package:flutter_test/flutter_test.dart';

/// Usage: the user has accessibility features enabled
Future<void> theUserHasAccessibilityFeaturesEnabled(WidgetTester tester) async {
  // Check if accessibility features are enabled
  final isAccessibilityEnabled = tester.binding.accessibilityFeatures;
}
