import 'package:fintracker/screens/onboard/widgets/profile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Profile Setup', () {
    testWidgets('User enters a valid name', (tester) async {
      await tester.pumpWidget(ProfileWidget(onGetStarted: () {}));

      // Implement your test steps here
      await tester.pumpAndSettle();

      // Verify the welcome text is displayed
      expect(find.text('Hi! welcome to Fintracker'), findsOneWidget);

      // Enter a valid name
      await tester.enterText(find.byType(TextFormField), 'John Doe');

      // Tap the Next button
      await tester.tap(find.text('Next'));
      await tester.pumpAndSettle();

      // Verify that the onGetStarted callback is called
      // Note: You might need to modify your widget to expose a way to check if the callback was called
      // For example, you could use a ValueNotifier or a mock function for testing
    });

    testWidgets('User tries to proceed without entering a name', (tester) async {
      await tester.pumpWidget(ProfileWidget(onGetStarted: () {}));
      await tester.pumpAndSettle();

      // Tap the Next button without entering a name
      await tester.tap(find.text('Next'));
      await tester.pumpAndSettle();

      // Verify that an error message is shown
      expect(find.text('Please enter your name'), findsOneWidget);
    });

    testWidgets('User interface elements are displayed correctly', (tester) async {
      await tester.pumpWidget(ProfileWidget(onGetStarted: () {}));
      await tester.pumpAndSettle();

      // Verify the wallet icon is displayed
      expect(find.byIcon(Icons.account_balance_wallet), findsOneWidget);

      // Verify the welcome text is displayed
      expect(find.text('Hi! welcome to Fintracker'), findsOneWidget);

      // Verify the name text field is displayed
      expect(find.byType(TextFormField), findsOneWidget);

      // Verify the Next button is displayed
      expect(find.text('Next'), findsOneWidget);
    });
  });
}
