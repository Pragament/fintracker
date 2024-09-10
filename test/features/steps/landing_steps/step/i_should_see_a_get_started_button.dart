import 'package:flutter_test/flutter_test.dart';

/// Usage: I should see a "Get Started" button
Future<void> iShouldSeeAGetStartedButton(WidgetTester tester) async {
  expect(find.text('Get Started'), findsOneWidget);
}
