import 'package:flutter_test/flutter_test.dart';

/// Usage: they should see an account slider
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fintracker/screens/home/home.screen.dart';
Future<void> theyShouldSeeAnAccountSlider(WidgetTester tester) async {
  await tester.pumpAndSettle();
}