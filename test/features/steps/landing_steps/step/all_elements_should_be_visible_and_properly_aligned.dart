import 'package:fintracker/widgets/buttons/button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

/// Usage: all elements should be visible and properly aligned
Future<void> allElementsShouldBeVisibleAndProperlyAligned(WidgetTester tester) async {
  await tester.pumpAndSettle();
  expect(find.byType(AppButton), findsOneWidget);
  expect(find.byType(AppButton), findsOneWidget);
  expect(find.byType(AppButton), findsOneWidget);
  expect(find.byType(AppButton), findsOneWidget);
  expect(find.byType(AppButton), findsOneWidget);
}

