import 'package:flutter_test/flutter_test.dart';

/// Usage: the application is being initialized
Future<void> theApplicationIsBeingInitialized(WidgetTester tester) async {
  await tester.pumpAndSettle();
}
