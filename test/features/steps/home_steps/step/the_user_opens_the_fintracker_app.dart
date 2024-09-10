import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

/// Usage: the user opens the FinTracker app
Future<void> theUserOpensTheFintrackerApp(WidgetTester tester) async {
  await tester.pumpWidget(const MaterialApp(home: Scaffold()));
}
