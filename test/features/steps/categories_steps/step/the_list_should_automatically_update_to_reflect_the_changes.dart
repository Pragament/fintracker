import 'package:flutter_test/flutter_test.dart';

/// Usage: the list should automatically update to reflect the changes
Future<void> theListShouldAutomaticallyUpdateToReflectTheChanges(
    WidgetTester tester) async {
  await tester.pumpAndSettle();
}
