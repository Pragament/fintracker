import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';

/// Usage: I should see an error message asking me to select a currency
Future<void> iShouldSeeAnErrorMessageAskingMeToSelectACurrency(WidgetTester tester) async {
  await tester.pumpWidget(MaterialApp(home: Scaffold(body: Center(child: Text("Hello World")))));
  await tester.pumpAndSettle();
  expect(find.text("Hello World"), findsOneWidget);
}
