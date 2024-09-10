import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

/// Usage: the user should see the "Fintracker" title
Future<void> theUserShouldSeeTheFintrackerTitle(WidgetTester tester) async {
  // Verify the title is visible
  expect(find.text('Fintracker'), findsOneWidget);
}
