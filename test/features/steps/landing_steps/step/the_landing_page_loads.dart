import 'package:fintracker/screens/onboard/widgets/landing.dart';
import 'package:fintracker/widgets/buttons/button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

/// Usage: the landing page loads

Future<void> theLandingPageLoads(WidgetTester tester) async {
  await tester.pumpWidget(
    MaterialApp(
      home: LandingPage(onGetStarted: () {}),
    ),
  );

  // Verify the app title is present
  expect(find.text('Fintracker'), findsOneWidget);

  // Verify the subtitle is present
  expect(find.text('Easy method to manage your savings'), findsOneWidget);

  // Verify the three feature points are present
  expect(find.text('Using our app, manage your finances.'), findsOneWidget);
  expect(find.text('Simple expense monitoring for more accurate budgeting'), findsOneWidget);
  expect(find.text('Keep track of your spending whenever and wherever you are.'), findsOneWidget);

  // Verify the beta disclaimer is present
  expect(find.text('*Since this application is currently in beta, be prepared for UI changes and unexpected behaviours.'), findsOneWidget);

  // Verify the "Get Started" button is present
  expect(find.widgetWithText(AppButton, 'Get Started'), findsOneWidget);

  // Verify the presence of check icons
  expect(find.byIcon(Icons.check_circle), findsNWidgets(3));
}
