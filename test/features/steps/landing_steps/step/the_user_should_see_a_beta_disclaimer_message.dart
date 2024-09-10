import 'package:fintracker/screens/onboard/widgets/landing.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';

/// Usage: the user should see a beta disclaimer message
Future<void> theUserShouldSeeABetaDisclaimerMessage(WidgetTester tester) async {
  await tester.pumpWidget(
    MaterialApp(
      home: LandingPage(
        onGetStarted: () {},
      ),
    ),
  );}

