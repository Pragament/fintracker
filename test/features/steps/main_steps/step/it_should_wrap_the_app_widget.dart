import 'package:flutter_test/flutter_test.dart';

/// Usage: it should wrap the App widget
Future<void> itShouldWrapTheAppWidget(WidgetTester tester) async {
  await tester.pumpAndSettle();
}
