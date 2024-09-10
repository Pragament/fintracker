import 'package:flutter_test/flutter_test.dart';

/// Usage: the initial app state is retrieved
Future<void> theInitialAppStateIsRetrieved(WidgetTester tester) async {
  await tester.pumpAndSettle();
}
