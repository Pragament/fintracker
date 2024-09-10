import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

/// Usage: the subtitle should be in a lighter shade of the primary color
void theSubtitleShouldBeInALighterShadeOfThePrimaryColor(WidgetTester tester) {
  // Get the primary color from the theme
  final primaryColor = Theme.of(tester.element(find.byType(Scaffold))).primaryColor;}
