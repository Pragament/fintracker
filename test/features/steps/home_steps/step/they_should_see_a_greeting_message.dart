import 'package:fintracker/screens/home/home.screen.dart';
import 'package:flutter_test/flutter_test.dart';

/// Usage: they should see a greeting message
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fintracker/screens/home/home.screen.dart';

Future<void> theyShouldSeeAGreetingMessage(WidgetTester tester) async {
  await tester.pumpAndSettle();
  expect(find.text('Welcome, Guest!'), findsOneWidget);
}
