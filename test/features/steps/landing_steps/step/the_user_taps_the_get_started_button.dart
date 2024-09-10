import 'package:fintracker/screens/onboard/widgets/landing.dart';
import 'package:fintracker/widgets/buttons/button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

/// Usage: the user taps the "Get Started" button
Future<void> theUserTapsTheGetStartedButton(WidgetTester tester) async {
  final button = find.byType(AppButton);
  await tester.tap(button);
  await tester.pumpAndSettle();
}

