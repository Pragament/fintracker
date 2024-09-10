import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

/// Usage: the user has launched the app
Future<void> theUserHasLaunchedTheApp(WidgetTester tester) async {
  await tester.pumpWidget(const MaterialApp(home: Text('Hello World')));
}
