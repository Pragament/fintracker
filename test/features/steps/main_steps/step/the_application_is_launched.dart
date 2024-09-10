import 'package:flutter_test/flutter_test.dart';

/// Usage: the application is launched
Future<void> theApplicationIsLaunched(WidgetTester tester) async {
  await tester.pumpAndSettle();
}
