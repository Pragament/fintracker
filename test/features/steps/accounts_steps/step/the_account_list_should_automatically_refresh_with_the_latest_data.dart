import 'package:flutter_test/flutter_test.dart';

/// Usage: the account list should automatically refresh with the latest data
Future<void> theAccountListShouldAutomaticallyRefreshWithTheLatestData(
    WidgetTester tester) async {
  await tester.pumpAndSettle();
}
