import 'package:flutter_test/flutter_test.dart';

/// Usage: I should see a progress bar indicating the expense against the budget
Future<void> iShouldSeeAProgressBarIndicatingTheExpenseAgainstTheBudget(
    WidgetTester tester) async {
  await tester.pumpAndSettle();
}
