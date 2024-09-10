import 'package:flutter_test/flutter_test.dart';

/// Usage: the screen loads
Future<void> theScreenLoads(WidgetTester tester) async {
  await tester.pumpAndSettle();
}
