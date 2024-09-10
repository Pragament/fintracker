import 'package:flutter_test/flutter_test.dart';

/// Usage: a confirmation dialog should appear
Future<void> aConfirmationDialogShouldAppear(WidgetTester tester) async {
  await tester.pumpAndSettle();
}
