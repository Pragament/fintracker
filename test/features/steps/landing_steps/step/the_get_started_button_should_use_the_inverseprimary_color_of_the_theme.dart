import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

/// Usage: the "Get Started" button should use the inversePrimary color of the theme
Future<void> theGetStartedButtonShouldUseTheInverseprimaryColorOfTheTheme(WidgetTester tester) async {
  // Arrange
  final theme = ThemeData(
    colorScheme: ColorScheme.fromSwatch(
      primarySwatch: Colors.blue,
      brightness: Brightness.light,
    ),
  );}
