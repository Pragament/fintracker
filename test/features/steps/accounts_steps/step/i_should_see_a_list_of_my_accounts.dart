import 'package:flutter_test/flutter_test.dart';

/// Usage: I should see a list of my accounts
Future<void> iShouldSeeAListOfMyAccounts(WidgetTester tester) async {
  await tester.pumpAndSettle();
}
