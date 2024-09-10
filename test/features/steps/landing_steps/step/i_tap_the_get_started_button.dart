import 'package:flutter_test/flutter_test.dart';

/// Usage: I tap the "Get Started" button
Future<void> iTapTheGetStartedButton(WidgetTester tester) async {
  expect(find.text('Get Started'), findsOneWidget);
  await tester.tap(find.text('Get Started'));
  await tester.pumpAndSettle();
}
