import 'package:flutter_test/flutter_test.dart';

/// Usage: the AppCubit should be provided with the initial app state
Future<void> theAppcubitShouldBeProvidedWithTheInitialAppState(
    WidgetTester tester) async {
  await tester.pumpAndSettle();
}
