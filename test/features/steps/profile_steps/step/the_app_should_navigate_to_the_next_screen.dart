import 'package:flutter_test/flutter_test.dart';

/// Usage: the app should navigate to the next screen
Future<void> theAppShouldNavigateToTheNextScreen(WidgetTester tester) async {
  await tester.pump();}
