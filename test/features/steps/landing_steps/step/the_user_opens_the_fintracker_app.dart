import 'package:fintracker/app.dart';
import 'package:fintracker/screens/onboard/widgets/landing.dart';
import 'package:fintracker/widgets/buttons/button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

/// Usage: the user opens the Fintracker app
// Future<void> theUserOpensTheFintrackerApp(WidgetTester tester) async {
//   throw UnimplementedError();
//}
Future<void> theUserOpensTheFintrackerApp(WidgetTester tester) async {
  await tester.pumpWidget(
    MaterialApp(
      home: LandingPage(
        onGetStarted: ()async {
          // This callback can be empty for now or filled with navigation logic later
          final widget = App();
            await tester.pumpWidget(widget);
        },
      ),
    ),
  );

  // Verify that the app title is visible
  expect(find.text('Fintracker'), findsOneWidget);

  // Verify that the subtitle is visible
  expect(find.text('Easy method to manage your savings'), findsOneWidget);

  // Verify that the "Get Started" button is present
  expect(find.widgetWithText(AppButton, 'Get Started'), findsOneWidget);

  // You can add more verifications here as needed
}
