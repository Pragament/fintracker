import 'package:flutter_test/flutter_test.dart';

/// Usage: the beta disclaimer should be visible
Future<void> theBetaDisclaimerShouldBeVisible(WidgetTester tester) async {
  // Check if the beta disclaimer is visible
  final isBetaDisclaimerVisible = tester.binding.accessibilityFeatures;
}
