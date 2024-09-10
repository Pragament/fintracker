import 'package:fintracker/screens/onboard/widgets/landing.dart';
import 'package:fintracker/widgets/buttons/button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

/// Usage: I am a new user opening the Fintracker app
Future<void> iAmANewUserOpeningTheFintrackerApp(WidgetTester tester) async {
  await tester.pumpWidget(
    MaterialApp(
      home: LandingPage(
        onGetStarted: () {},
      ),
    ),
  );
}

