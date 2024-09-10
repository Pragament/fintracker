# FinTracker - Expense Tracker App

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)

FinTracker is a Flutter application that helps you track your expenses and manage category budgets. It provides a user-friendly interface to enter and categorize your expenses, giving you insights into your spending habits and helping you stay within your budget.

![FinTracker Screenshot](screenshots/fintracker_screenshot.jpg)


## Download

You can download FinTracker from the Google Play Store:

[![Google Play Store](https://img.shields.io/badge/Download-Play%20Store-brightgreen.svg)](https://play.google.com/store/apps/details?id=me.nafish.fintracker)

## Features

- Track and record your expenses conveniently.
- Categorize your expenses into different categories.
- Set monthly budgets for each category and monitor your spending.
- View detailed expense reports and statistics.
- Easily search and filter your expenses.
- Export expense data for further analysis.

## Installation

1. Clone the repository:

```bash
git clone https://github.com/nafishahmeddev/fintracker.git
```

2. Change to the project directory:

```bash
cd fintracker
```

3. Install dependencies:

```bash
flutter pub get
```

4. Run the app:

```bash
flutter run
```

## Usage

- Upon launching the app, you will be presented with the home screen.
- Click on the "+" button to add a new expense.
- Enter the expense details, including the amount, category, and description.
- Click "Save" to add the expense.
- Navigate to the "Categories" tab to manage your expense categories and budgets.
- Set monthly budgets for each category by clicking on the category and entering the desired amount.

## Contributing

Contributions are welcome! If you find any issues or have suggestions for improvements, please open an issue or submit a pull request.

## License

This project is licensed under the MIT License. See the [LICENSE](LICENSE) file for more information.

## Acknowledgements

- This app was built using the Flutter framework. Learn more about Flutter at [flutter.dev](https://flutter.dev).
- The design and inspiration for this app came from various expense tracker apps available in the market.
- Special thanks to the open-source community for their valuable contributions.

## Contact

For any questions or inquiries, please email us at [hello@nafish.me](mailto:hello@nafish.me).


# BDD Scenarios and Features

# Prerequisites

BDD Framework: Add the bdd_widget_test package to your pubspec.yaml file.

dependencies:
  flutter:
    sdk: flutter
  bdd_widget_test: latest_version

Testing Framework: Ensure you have flutter_test or any other testing package installed.


# Steps to Generate BDD Scenarios and Features

1. Define Feature Files

Create a new feature file inside the test/features directory. This file should describe the behavior of your app in natural language.

Feature: Landing Page for Fintracker App

  As a new user of the Fintracker app
  I want to see an informative landing page
  So that I can understand the app's purpose and get started

  Scenario: Viewing the Landing Page
    Given I am a new user opening the Fintracker app
    When I arrive at the landing page
    Then I should see the app name "Fintracker"
    And I should see the tagline "Easy method to manage your savings"
    And I should see 3 key features of the app
    And I should see a "Get Started" button

  Scenario: Starting the onboarding process
    Given I am on the landing page
    When I tap the "Get Started" button
    Then the onboarding process should begin


2. Write Step Definitions

In your Dart code, create step definitions that correspond to the scenarios written in your feature file. Step definitions map the steps in your Gherkin scenarios to executable Dart code.


import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:bdd_widget_test/bdd_widget_test.dart';

void main() {
  BddWidgetTest().execute([
    group('''FinTracker Home Screen''', () {
      testWidgets('''User views the home screen''', (tester) async {
        await givenTheUserOpensTheFintrackerApp(tester);
        await thenTheyShouldSeeTheirUsernameOrGuest(tester);
      });

      testWidgets('''User views account information''', (tester) async {
        await givenTheUserIsOnTheHomeScreen(tester);
        await thenTheyShouldSeeAnAccountSlider(tester);
        await andTheSliderShouldDisplayAccountBalances(tester);
        await andTheSliderShouldShowAccountHolderNames(tester);
      });

      testWidgets('''User views payment summary''', (tester) async {
        await givenTheUserIsOnTheHomeScreen(tester);
        await thenTheyShouldSeeAnIncomeSummary(tester);
        await andTheyShouldSeeAnExpenseSummary(tester);
      });

      testWidgets('''User views payment list''', (tester) async {
        await givenTheUserIsOnTheHomeScreen(tester);
        await thenTheyShouldSeeAListOfRecentPayments(tester);
        await andEachPaymentShouldShowCategoryDateAndAmount(tester);
      });

      testWidgets('''User selects a date range''', (tester) async {
        await givenTheUserIsOnTheHomeScreen(tester);
        await whenTheyTapOnTheDateRangeButton(tester);
        await thenTheyShouldBeAbleToSelectACustomDateRange(tester);
        await andThePaymentListShouldUpdateAccordingly(tester);
      });

      testWidgets('''User adds a new payment''', (tester) async {
        await givenTheUserIsOnTheHomeScreen(tester);
        await whenTheyTapTheFloatingActionButton(tester);
        await thenTheyShouldBeTakenToThePaymentFormScreen(tester);
      });

      testWidgets('''User taps on a payment''', (tester) async {
        await givenTheUserIsOnTheHomeScreen(tester);
        await whenTheyTapOnAPaymentInTheList(tester);
        await thenTheyShouldBeTakenToThePaymentFormScreenForThatPayment(tester);
      });

      testWidgets('''User scrolls through accounts''', (tester) async {
        await givenTheUserIsOnTheHomeScreen(tester);
        await whenTheySwipeOnTheAccountSlider(tester);
        await thenTheyShouldSeeDifferentAccountCards(tester);
        await andTheIndicatorDotsShouldUpdateToShowTheCurrentAccount(tester);
      });
    })
  ]);
}


# Step Definitions

Each of the step functions (e.g., givenTheUserOpensTheFintrackerApp) should be defined in separate files or grouped logically. Here's how you can define some of these step functions:

Future<void> givenTheUserOpensTheFintrackerApp(WidgetTester tester) async {
  // Code to simulate app opening
  await tester.pumpWidget(MyApp());
}

Future<void> thenTheyShouldSeeTheirUsernameOrGuest(WidgetTester tester) async {
  // Verify that the username or "Guest" is visible
  expect(find.text('Guest'), findsOneWidget);
}

Future<void> givenTheUserIsOnTheHomeScreen(WidgetTester tester) async {
  // Code to ensure the user is on the home screen
  await tester.pumpWidget(MyApp());
}

Future<void> thenTheyShouldSeeAnAccountSlider(WidgetTester tester) async {
  // Verify that the account slider is visible
  expect(find.byType(AccountSlider), findsOneWidget);
}

Future<void> andTheSliderShouldDisplayAccountBalances(WidgetTester tester) async {
  // Verify that account balances are displayed on the slider
  expect(find.text('Balance: \$1000'), findsWidgets);
}

Future<void> andTheSliderShouldShowAccountHolderNames(WidgetTester tester) async {
  // Verify that account holder names are displayed on the slider
  expect(find.text('John Doe'), findsWidgets);
}

Future<void> thenTheyShouldSeeAnIncomeSummary(WidgetTester tester) async {
  // Verify that the income summary is visible
  expect(find.text('Income Summary'), findsOneWidget);
}

Future<void> andTheyShouldSeeAnExpenseSummary(WidgetTester tester) async {
  // Verify that the expense summary is visible
  expect(find.text('Expense Summary'), findsOneWidget);
}

Future<void> thenTheyShouldSeeAListOfRecentPayments(WidgetTester tester) async {
  // Verify that a list of recent payments is visible
  expect(find.byType(PaymentList), findsOneWidget);
}

Future<void> andEachPaymentShouldShowCategoryDateAndAmount(WidgetTester tester) async {
  // Verify that each payment shows category, date, and amount
  expect(find.text('Groceries'), findsWidgets);
  expect(find.text('2023-08-01'), findsWidgets);
  expect(find.text('\$50'), findsWidgets);
}

Future<void> whenTheyTapOnTheDateRangeButton(WidgetTester tester) async {
  // Code to simulate tapping on the date range button
  await tester.tap(find.byKey(Key('date_range_button')));
  await tester.pumpAndSettle();
}

Future<void> thenTheyShouldBeAbleToSelectACustomDateRange(WidgetTester tester) async {
  // Verify that the custom date range selector is visible
  expect(find.byType(DateRangePicker), findsOneWidget);
}

Future<void> andThePaymentListShouldUpdateAccordingly(WidgetTester tester) async {
  // Verify that the payment list updates based on the selected date range
  expect(find.text('Payment on 2023-08-01'), findsOneWidget);
}

Future<void> whenTheyTapTheFloatingActionButton(WidgetTester tester) async {
  // Code to simulate tapping on the FAB
  await tester.tap(find.byType(FloatingActionButton));
  await tester.pumpAndSettle();
}

Future<void> thenTheyShouldBeTakenToThePaymentFormScreen(WidgetTester tester) async {
  // Verify that the payment form screen is displayed
  expect(find.byType(PaymentFormScreen), findsOneWidget);
}

Future<void> whenTheyTapOnAPaymentInTheList(WidgetTester tester) async {
  // Code to simulate tapping on a payment in the list
  await tester.tap(find.byType(PaymentListItem).first);
  await tester.pumpAndSettle();
}

Future<void> thenTheyShouldBeTakenToThePaymentFormScreenForThatPayment(WidgetTester tester) async {
  // Verify that the payment form screen is displayed for the selected payment
  expect(find.byType(PaymentFormScreen), findsOneWidget);
}

Future<void> whenTheySwipeOnTheAccountSlider(WidgetTester tester) async {
  // Code to simulate swiping on the account slider
  await tester.drag(find.byType(AccountSlider), Offset(-300, 0));
  await tester.pumpAndSettle();
}

Future<void> thenTheyShouldSeeDifferentAccountCards(WidgetTester tester) async {
  // Verify that different account cards are displayed after swiping
  expect(find.text('Savings Account'), findsOneWidget);
}

Future<void> andTheIndicatorDotsShouldUpdateToShowTheCurrentAccount(WidgetTester tester) async {
  // Verify that the indicator dots update to show the current account
  expect(find.byType(IndicatorDots), findsOneWidget);
}


# Folder Structure

You can organize your step definitions in a folder structure like this:

test/
  steps/
    home_steps/
      step/
        the_user_opens_the_fintracker_app.dart
        they_should_see_their_username_or_guest.dart
        the_user_is_on_the_home_screen.dart
        they_should_see_an_account_slider.dart
        the_slider_should_display_account_balances.dart
        the_slider_should_show_account_holder_names.dart
        they_should_see_an_income_summary.dart
        they_should_see_an_expense_summary.dart
        they_should_see_a_list_of_recent_payments.dart
        each_payment_should_show_category_date_and_amount.dart
        they_tap_on_the_date_range_button.dart
        they_should_be_able_to_select_a_custom_date_range.dart
        the_payment_list_should_update_accordingly.dart
        they_tap_the_floating_action_button.dart
        they_should_be_taken_to_the_payment_form_screen.dart
        they_tap_on_a_payment_in_the_list.dart
        they_should_be_taken_to_the_payment_form_screen_for_that_payment.dart
        they_swipe_on_the_account_slider.dart
        they_should_see_different_account_cards.dart
        the_indicator_dots_should_update_to_show_the_current_account.dart
