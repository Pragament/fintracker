import 'package:flutter_test/flutter_test.dart';

/// Usage: the App should be wrapped in a MultiBlocProvider
Future<void> theAppShouldBeWrappedInAMultiblocprovider(
    WidgetTester tester) async {
  await tester.pumpAndSettle();
}
