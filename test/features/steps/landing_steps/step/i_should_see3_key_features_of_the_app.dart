import 'package:fintracker/screens/onboard/widgets/landing.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';


Future<void> iShouldSee3KeyFeaturesOfTheApp(WidgetTester tester) async {
  // Verify that there are 3 rows with check icons
  expect(find.byIcon(Icons.check_circle), findsNWidgets(3));

  // Verify the text of each feature
  expect(find.text('Using our app, manage your finances.'), findsOneWidget);
  expect(find.text('Simple expense monitoring for more accurate budgeting'), findsOneWidget);
  expect(find.text('Keep track of your spending whenever and wherever you are.'), findsOneWidget);

  // Verify that each feature is in a row with an icon
  for (final featureText in [
    'Using our app, manage your finances.',
    'Simple expense monitoring for more accurate budgeting',
    'Keep track of your spending whenever and wherever you are.'
  ]) {
    expect(
      find.ancestor(
        of: find.text(featureText),
        matching: find.byType(Row),
      ),
      findsOneWidget,
    );
  }

  // Verify that the icons are the primary color of the theme
  final iconColor = Theme.of(tester.element(find.byType(LandingPage))).colorScheme.primary;
  final icons = tester.widgetList<Icon>(find.byIcon(Icons.check_circle));
  for (final icon in icons) {
    expect(icon.color, iconColor);
  }
}

