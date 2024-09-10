import 'dart:ui';

import 'package:fintracker/screens/onboard/widgets/landing.dart';
import 'package:fintracker/widgets/buttons/button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

/// Usage: I view the page on different screen sizes
Future<void> iViewThePageOnDifferentScreenSizes(WidgetTester tester) async {
  await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: LandingPage(
            onGetStarted: () {},
          ),
        ),
      ));
}

