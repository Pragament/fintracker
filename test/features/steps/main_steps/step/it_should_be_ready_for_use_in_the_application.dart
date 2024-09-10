import 'package:flutter_test/flutter_test.dart';

/// Usage: it should be ready for use in the application
Future<void> itShouldBeReadyForUseInTheApplication(WidgetTester tester) async {
  await tester.pumpAndSettle();
}
