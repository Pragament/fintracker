import 'package:flutter_test/flutter_test.dart';

/// Usage: I should see the tagline "Easy method to manage your savings"
void iShouldSeeTheTaglineEasyMethodToManageYourSavings(WidgetTester tester) {
  // Find the text widget with "Easy method to manage your savings"
  final taglineFinder = find.text('Easy method to manage your savings');
  expect(taglineFinder, findsOneWidget);}
