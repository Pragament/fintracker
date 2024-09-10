import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

/// Usage: all content should be within the safe area


Future<void> allContentShouldBeWithinTheSafeArea(WidgetTester tester) async {
  // Get the safe area
  final safeArea = MediaQuery.of(tester.element(find.byType(SafeArea))).padding;}
