import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

/// Usage: the user navigates to the Profile screen
Future<void> theUserNavigatesToTheProfileScreen(WidgetTester tester) async {
  await tester.pumpWidget(
    MaterialApp(
      home: Scaffold(
        body: Center(
          child: Text('Profile Screen'),
        ),
      ),
    ),
  );
  await tester.pumpAndSettle();
}
