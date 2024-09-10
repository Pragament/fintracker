import 'package:flutter_test/flutter_test.dart';

/// Usage: the application is starting
Future<void> theApplicationIsStarting(WidgetTester tester) async {
  await tester.pumpAndSettle();
}
