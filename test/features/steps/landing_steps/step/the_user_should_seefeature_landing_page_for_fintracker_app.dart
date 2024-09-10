import 'package:flutter_test/flutter_test.dart';

/// Usage: the user should seeFeature: Landing Page for Fintracker App
Future<void> theUserShouldSeeFeatureLandingPageForFintrackerApp(WidgetTester tester) async {
  // Verify the landing page is displayed
  expect(find.text('Fintracker'), findsOneWidget);
}
