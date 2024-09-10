import 'package:fintracker/screens/onboard/widgets/landing.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

/// Usage: the user should see a "Get Started" button at the bottom
Future<void> theUserShouldSeeAGetStartedButtonAtTheBottom(WidgetTester tester) async {
  await tester.pumpWidget(
    MaterialApp(
      home: LandingPage(
        onGetStarted: () {},
      ),
    ),
  );
}
