import 'package:flutter_test/flutter_test.dart';

/// Usage: the app should reset the database
Future<void> theAppShouldResetTheDatabase(WidgetTester tester) async {
  await tester.pumpAndSettle();
}
