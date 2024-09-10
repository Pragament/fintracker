import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

/// Usage: I should see the app name "Fintracker"
void iShouldSeeTheAppNameFintracker(WidgetTester tester) {
  // Find the text widget with "Fintracker"
  final appNameFinder = find.text('Fintracker');
  expect(appNameFinder, findsOneWidget);}

