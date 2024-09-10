import 'package:flutter_test/flutter_test.dart';

/// Usage: the database instance should be successfully obtained
Future<void> theDatabaseInstanceShouldBeSuccessfullyObtained(
    WidgetTester tester) async {
  await tester.pumpAndSettle();
}
