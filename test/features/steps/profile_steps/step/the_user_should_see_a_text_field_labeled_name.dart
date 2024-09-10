import 'package:fintracker/screens/onboard/widgets/profile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

/// Usage: the user should see a text field labeled "Name"
Future<void> theUserShouldSeeATextFieldLabeledName(
    WidgetTester tester)async {
  expect(find.text('Name'), findsOneWidget);
}
