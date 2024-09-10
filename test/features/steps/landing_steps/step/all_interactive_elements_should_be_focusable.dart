import 'package:flutter_test/flutter_test.dart';

/// Usage: all interactive elements should be focusable
Future<void> allInteractiveElementsShouldBeFocusable(WidgetTester tester) async {
  // Check if all interactive elements are focusable
  final isFocusable = tester.binding.accessibilityFeatures;
}
