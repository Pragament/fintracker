import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

/// Usage: the app has a custom theme
Future<void> theAppHasACustomTheme(WidgetTester tester) async {
  await tester.pumpWidget(
    MaterialApp(
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.deepPurple,
        ),
      ),
      home: const Scaffold(
        body: Center(
          child: Text('Hello, world!'),
        ),
      ),
    ),
  );
}
