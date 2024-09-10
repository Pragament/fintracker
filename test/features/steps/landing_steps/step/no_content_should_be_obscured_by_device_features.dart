import 'package:fintracker/widgets/buttons/button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

/// Usage: no content should be obscured by device features
Future<void> noContentShouldBeObscuredByDeviceFeatures(WidgetTester tester) async {
 // Get the safe area
  final safeArea = MediaQuery.of(tester.element(find.byType(SafeArea))).padding;
}

