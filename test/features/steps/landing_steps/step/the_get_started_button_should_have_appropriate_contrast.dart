import 'package:fintracker/widgets/buttons/button.dart';
import 'package:flutter_test/flutter_test.dart';

/// Usage: the "Get Started" button should have appropriate contrast
Future<void> theGetStartedButtonShouldHaveAppropriateContrast(WidgetTester tester) async {
  // Get the "Get Started" button
  final getStartedButton = find.byType(AppButton);}
