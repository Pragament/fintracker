// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: unused_import, directives_ordering

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'steps/currency_pic_steps/step/i_am_on_the_currency_selection_screen.dart';
import 'steps/currency_pic_steps/step/i_should_see_a_list_of_available_currencies.dart';
import 'steps/currency_pic_steps/step/each_currency_should_display_its_name_code_and_symbol.dart';
import 'steps/currency_pic_steps/step/i_enter_a_search_term_in_the_search_field.dart';
import 'steps/currency_pic_steps/step/the_list_should_filter_to_show_only_matching_currencies.dart';
import 'steps/currency_pic_steps/step/i_tap_on_a_currency.dart';
import 'steps/currency_pic_steps/step/the_selected_currency_should_be_visually_highlighted.dart';
import 'steps/currency_pic_steps/step/i_have_selected_a_currency.dart';
import 'steps/currency_pic_steps/step/i_tap_the_next_button.dart';
import 'steps/currency_pic_steps/step/the_app_should_update_to_use_the_selected_currency.dart';
import 'steps/currency_pic_steps/step/i_should_be_taken_to_the_next_screen.dart';
import 'steps/currency_pic_steps/step/i_have_not_selected_any_currency.dart';
import 'steps/currency_pic_steps/step/i_should_see_an_error_message_asking_me_to_select_a_currency.dart';
import 'steps/currency_pic_steps/step/the_app_should_reset_the_database.dart';
import 'steps/currency_pic_steps/step/i_have_previously_selected_a_currency.dart';
import 'steps/currency_pic_steps/step/i_return_to_the_currency_selection_screen.dart';
import 'steps/currency_pic_steps/step/my_previously_selected_currency_should_be_highlighted.dart';

void main() {
  group('''Currency Selection''', () {
    Future<void> bddSetUp(WidgetTester tester) async {
      await iAmOnTheCurrencySelectionScreen(tester);
    }

    testWidgets('''Viewing available currencies''', (tester) async {
      await bddSetUp(tester);
      await iShouldSeeAListOfAvailableCurrencies(tester);
      await eachCurrencyShouldDisplayItsNameCodeAndSymbol(tester);
    });
    testWidgets('''Searching for a currency''', (tester) async {
      await bddSetUp(tester);
      await iEnterASearchTermInTheSearchField(tester);
      await theListShouldFilterToShowOnlyMatchingCurrencies(tester);
    });
    testWidgets('''Selecting a currency''', (tester) async {
      await bddSetUp(tester);
      await iTapOnACurrency(tester);
      await theSelectedCurrencyShouldBeVisuallyHighlighted(tester);
    });
    testWidgets('''Proceeding with selected currency''', (tester) async {
      await bddSetUp(tester);
      await iHaveSelectedACurrency(tester);
      await iTapTheNextButton(tester);
      await theAppShouldUpdateToUseTheSelectedCurrency(tester);
      await iShouldBeTakenToTheNextScreen(tester);
    });
    testWidgets('''Attempting to proceed without selecting a currency''',
        (tester) async {
      await bddSetUp(tester);
      await iHaveNotSelectedAnyCurrency(tester);
      await iTapTheNextButton(tester);
      await iShouldSeeAnErrorMessageAskingMeToSelectACurrency(tester);
    });
    testWidgets('''Resetting the database after currency selection''',
        (tester) async {
      await bddSetUp(tester);
      await iHaveSelectedACurrency(tester);
      await iTapTheNextButton(tester);
      await theAppShouldResetTheDatabase(tester);
    });
    testWidgets('''Displaying current currency selection''', (tester) async {
      await bddSetUp(tester);
      await iHavePreviouslySelectedACurrency(tester);
      await iReturnToTheCurrencySelectionScreen(tester);
      await myPreviouslySelectedCurrencyShouldBeHighlighted(tester);
    });
  });
}
