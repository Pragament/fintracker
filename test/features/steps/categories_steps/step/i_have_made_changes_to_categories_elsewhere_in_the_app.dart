import 'package:flutter_test/flutter_test.dart';

/// Usage: I have made changes to categories elsewhere in the app
Future<void> iHaveMadeChangesToCategoriesElsewhereInTheApp(
    WidgetTester tester) async {
  await tester.pumpAndSettle();
}
