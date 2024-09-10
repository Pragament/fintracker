import 'package:fintracker/widgets/buttons/button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

/// Usage: I tap the "Next" button
Future<void> iTapTheNextButton(WidgetTester tester) async {
  //await tester.tap(find.byType(AppButton));
  await tester.pumpAndSettle();
}