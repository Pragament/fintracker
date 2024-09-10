import 'package:flutter_test/flutter_test.dart';

/// Usage: I arrive at the landing page
Future<void> iArriveAtTheLandingPage(WidgetTester tester) async {
  // Verify the landing page is displayed
  expect(find.text('Fintracker'), findsOneWidget);
}
