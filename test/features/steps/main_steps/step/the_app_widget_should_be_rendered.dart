import 'package:flutter_test/flutter_test.dart';

/// Usage: the App widget should be rendered
Future<void> theAppWidgetShouldBeRendered(WidgetTester tester) async {
  await tester.pumpAndSettle();
}
