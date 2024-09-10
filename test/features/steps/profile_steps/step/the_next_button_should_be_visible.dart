import 'package:fintracker/screens/onboard/widgets/profile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

/// Usage: the "Next" button should be visible
Future<void> theNextButtonShouldBeVisible(WidgetTester tester) async {
  expect(find.byKey(const Key('next_button')), findsOneWidget);
}
