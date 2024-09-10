import 'package:flutter_test/flutter_test.dart';

/// Usage: it should be initialized with the provided app state
Future<void> itShouldBeInitializedWithTheProvidedAppState(
    WidgetTester tester) async {
  await tester.pumpAndSettle();
}
