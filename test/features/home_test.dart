// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: unused_import, directives_ordering

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'steps/home_steps/step/the_user_opens_the_fintracker_app.dart';
import 'steps/home_steps/step/they_should_see_a_greeting_message.dart';
import 'steps/home_steps/step/they_should_see_their_username_or_guest.dart';
import 'steps/home_steps/step/the_user_is_on_the_home_screen.dart';
import 'steps/home_steps/step/they_should_see_an_account_slider.dart';
import 'steps/home_steps/step/the_slider_should_display_account_balances.dart';
import 'steps/home_steps/step/the_slider_should_show_account_holder_names.dart';
import 'steps/home_steps/step/they_should_see_an_income_summary.dart';
import 'steps/home_steps/step/they_should_see_an_expense_summary.dart';
import 'steps/home_steps/step/they_should_see_a_list_of_recent_payments.dart';
import 'steps/home_steps/step/each_payment_should_show_category_date_and_amount.dart';
import 'steps/home_steps/step/they_tap_on_the_date_range_button.dart';
import 'steps/home_steps/step/they_should_be_able_to_select_a_custom_date_range.dart';
import 'steps/home_steps/step/the_payment_list_should_update_accordingly.dart';
import 'steps/home_steps/step/they_tap_the_floating_action_button.dart';
import 'steps/home_steps/step/they_should_be_taken_to_the_payment_form_screen.dart';
import 'steps/home_steps/step/they_tap_on_a_payment_in_the_list.dart';
import 'steps/home_steps/step/they_should_be_taken_to_the_payment_form_screen_for_that_payment.dart';
import 'steps/home_steps/step/they_swipe_on_the_account_slider.dart';
import 'steps/home_steps/step/they_should_see_different_account_cards.dart';
import 'steps/home_steps/step/the_indicator_dots_should_update_to_show_the_current_account.dart';

void main() {
  group('''FinTracker Home Screen''', () {
    testWidgets('''User views the home screen''', (tester) async {
      await theUserOpensTheFintrackerApp(tester);
      await theyShouldSeeTheirUsernameOrGuest(tester);
    });
    testWidgets('''User views account information''', (tester) async {
      await theUserIsOnTheHomeScreen(tester);
      await theyShouldSeeAnAccountSlider(tester);
      await theSliderShouldDisplayAccountBalances(tester);
      await theSliderShouldShowAccountHolderNames(tester);
    });
    testWidgets('''User views payment summary''', (tester) async {
      await theUserIsOnTheHomeScreen(tester);
      await theyShouldSeeAnIncomeSummary(tester);
      await theyShouldSeeAnExpenseSummary(tester);
    });
    testWidgets('''User views payment list''', (tester) async {
      await theUserIsOnTheHomeScreen(tester);
      await theyShouldSeeAListOfRecentPayments(tester);
      await eachPaymentShouldShowCategoryDateAndAmount(tester);
    });
    testWidgets('''User selects a date range''', (tester) async {
      await theUserIsOnTheHomeScreen(tester);
      await theyTapOnTheDateRangeButton(tester);
      await theyShouldBeAbleToSelectACustomDateRange(tester);
      await thePaymentListShouldUpdateAccordingly(tester);
    });
    testWidgets('''User adds a new payment''', (tester) async {
      await theUserIsOnTheHomeScreen(tester);
      await theyTapTheFloatingActionButton(tester);
      await theyShouldBeTakenToThePaymentFormScreen(tester);
    });
    testWidgets('''User taps on a payment''', (tester) async {
      await theUserIsOnTheHomeScreen(tester);
      await theyTapOnAPaymentInTheList(tester);
      await theyShouldBeTakenToThePaymentFormScreenForThatPayment(tester);
    });
    testWidgets('''User scrolls through accounts''', (tester) async {
      await theUserIsOnTheHomeScreen(tester);
      await theySwipeOnTheAccountSlider(tester);
      await theyShouldSeeDifferentAccountCards(tester);
      await theIndicatorDotsShouldUpdateToShowTheCurrentAccount(tester);
    });
  });
}
