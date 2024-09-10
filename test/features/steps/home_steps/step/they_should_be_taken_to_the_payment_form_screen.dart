import 'package:flutter_test/flutter_test.dart';

/// Usage: they should be taken to the payment form screen
Future<void> theyShouldBeTakenToThePaymentFormScreen(
    WidgetTester tester) async {
  await tester.pumpAndSettle();
}
