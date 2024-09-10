import 'package:fintracker/screens/onboard/widgets/profile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

/// Usage: the user should see the message "Hi! welcome to Fintracker"
Future<void> theUserShouldSeeTheMessageHiWelcomeToFintracker(tester) async {
  await tester.pumpWidget(
    MaterialApp(
      home: Scaffold(
        body: ProfileWidget(onGetStarted: () {}),
      ),
    ),
  );
  await tester.pumpAndSettle();
}
