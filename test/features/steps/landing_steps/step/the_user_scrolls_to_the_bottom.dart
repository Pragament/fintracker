import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

/// Usage: the user scrolls to the bottom
Future<void> theUserScrollsToTheBottom(WidgetTester tester) async {
  // Scroll to the bottom of the page
  await tester.scrollUntilVisible(
    find.text('Get Started'),
    500.0,
    scrollable: find.byType(Scrollable).first
  );
}
