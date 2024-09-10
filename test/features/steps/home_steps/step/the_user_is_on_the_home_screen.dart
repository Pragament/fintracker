import 'package:flutter_test/flutter_test.dart';

/// Usage: the user is on the home screen
import 'package:flutter/material.dart';
import 'package:fintracker/screens/home/home.screen.dart';

Future<void> theUserIsOnTheHomeScreen(WidgetTester tester) async {
  await tester.pumpAndSettle();
}
