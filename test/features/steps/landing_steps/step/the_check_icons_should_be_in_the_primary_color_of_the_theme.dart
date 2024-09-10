import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

/// Usage: the check icons should be in the primary color of the theme
void theCheckIconsShouldBeInThePrimaryColorOfTheTheme(WidgetTester tester) {
  // Get the primary color from the theme
  final primaryColor = Theme.of(tester.element(find.byType(Scaffold))).primaryColor;}
