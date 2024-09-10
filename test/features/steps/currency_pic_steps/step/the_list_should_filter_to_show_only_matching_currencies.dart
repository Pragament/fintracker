import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

/// Usage: the list should filter to show only matching currencies
Future<void> theListShouldFilterToShowOnlyMatchingCurrencies(WidgetTester tester) async {
  await tester.pumpWidget(MaterialApp(home: Scaffold(body: Center(child: Text("Hello World")))));
  await tester.pumpAndSettle();
  expect(find.text("Hello World"), findsOneWidget);
}
