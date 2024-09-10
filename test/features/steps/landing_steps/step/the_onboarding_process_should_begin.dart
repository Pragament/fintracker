import 'package:fintracker/screens/onboard/widgets/landing.dart';
import 'package:fintracker/widgets/buttons/button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

/// Usage: the onboarding process should begin
Future<void> theOnboardingProcessShouldBegin(WidgetTester tester) async {
  await tester.pumpWidget(
    MaterialApp(
      home: LandingPage(
        onGetStarted: () {},
      ),
    ),
  );
}

