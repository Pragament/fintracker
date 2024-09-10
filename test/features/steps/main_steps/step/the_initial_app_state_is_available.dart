import 'package:flutter_test/flutter_test.dart';

/// Usage: the initial app state is available
Future<void> theInitialAppStateIsAvailable(WidgetTester tester) async {
  await tester.pumpAndSettle();
}
