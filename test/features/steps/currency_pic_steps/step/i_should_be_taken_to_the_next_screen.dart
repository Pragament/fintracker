import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

/// Usage: I should be taken to the next screen
Future<void> iShouldBeTakenToTheNextScreen(WidgetTester tester) async {
  await tester.pumpWidget(MaterialApp(home: Scaffold(body: Center(child: Text("Hello World")))));
  await tester.pumpAndSettle();
  expect(find.text("Hello World"), findsOneWidget);
}
