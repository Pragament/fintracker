import 'package:flutter_test/flutter_test.dart';

/// Usage: the user should see the subtitle "Easy method to manage your savings"
Future<void> theUserShouldSeeTheSubtitleEasyMethodToManageYourSavings(WidgetTester tester) async {
  // Verify the subtitle is visible
  expect(find.text('Easy method to manage your savings'), findsOneWidget);
}
