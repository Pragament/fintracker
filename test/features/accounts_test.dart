// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: unused_import, directives_ordering

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'steps/accounts_steps/step/i_am_on_the_accounts_screen.dart';
import 'steps/accounts_steps/step/the_screen_loads.dart';
import 'steps/accounts_steps/step/i_should_see_a_list_of_my_accounts.dart';
import 'steps/accounts_steps/step/each_account_should_display_holder_name_account_name_masked_account_number_and_balance.dart';
import 'steps/accounts_steps/step/i_look_at_an_account_in_the_list.dart';
import 'steps/accounts_steps/step/i_should_see_the_total_balance_income_and_expense_for_that_account.dart';
import 'steps/accounts_steps/step/i_tap_the_floating_action_button.dart';
import 'steps/accounts_steps/step/the_account_form_dialog_should_open.dart';
import 'steps/accounts_steps/step/i_should_be_able_to_enter_details_for_a_new_account.dart';
import 'steps/accounts_steps/step/i_tap_the_more_options_button_for_an_account.dart';
import 'steps/accounts_steps/step/i_select_edit_from_the_menu.dart';
import 'steps/accounts_steps/step/the_account_form_dialog_should_open_with_the_accounts_current_details.dart';
import 'steps/accounts_steps/step/i_should_be_able_to_modify_the_account_information.dart';
import 'steps/accounts_steps/step/i_select_delete_from_the_menu.dart';
import 'steps/accounts_steps/step/a_confirmation_dialog_should_appear.dart';
import 'steps/accounts_steps/step/i_confirm_the_deletion.dart';
import 'steps/accounts_steps/step/the_account_should_be_removed_from_the_list.dart';
import 'steps/accounts_steps/step/theres_an_update_to_account_information.dart';
import 'steps/accounts_steps/step/the_account_list_should_automatically_refresh_with_the_latest_data.dart';
import 'steps/accounts_steps/step/i_view_an_account_in_the_list.dart';
import 'steps/accounts_steps/step/i_should_see_the_accounts_color_theme_applied_to_its_container.dart';
import 'steps/accounts_steps/step/i_should_see_the_accounts_icon_displayed.dart';

void main() {
  group('''Account Management Screen''', () {
    Future<void> bddSetUp(WidgetTester tester) async {
      await iAmOnTheAccountsScreen(tester);
    }

    testWidgets('''View list of accounts''', (tester) async {
      await bddSetUp(tester);
      await theScreenLoads(tester);
      await iShouldSeeAListOfMyAccounts(tester);
      await eachAccountShouldDisplayHolderNameAccountNameMaskedAccountNumberAndBalance(
          tester);
    });
    testWidgets('''View account details''', (tester) async {
      await bddSetUp(tester);
      await iLookAtAnAccountInTheList(tester);
      await iShouldSeeTheTotalBalanceIncomeAndExpenseForThatAccount(tester);
    });
    testWidgets('''Add a new account''', (tester) async {
      await bddSetUp(tester);
      await iTapTheFloatingActionButton(tester);
      await theAccountFormDialogShouldOpen(tester);
      await iShouldBeAbleToEnterDetailsForANewAccount(tester);
    });
    testWidgets('''Edit an existing account''', (tester) async {
      await bddSetUp(tester);
      await iTapTheMoreOptionsButtonForAnAccount(tester);
      await iSelectEditFromTheMenu(tester);
      await theAccountFormDialogShouldOpenWithTheAccountsCurrentDetails(tester);
      await iShouldBeAbleToModifyTheAccountInformation(tester);
    });
    testWidgets('''Delete an account''', (tester) async {
      await bddSetUp(tester);
      await iTapTheMoreOptionsButtonForAnAccount(tester);
      await iSelectDeleteFromTheMenu(tester);
      await aConfirmationDialogShouldAppear(tester);
      await iConfirmTheDeletion(tester);
      await theAccountShouldBeRemovedFromTheList(tester);
    });
    testWidgets('''Refresh account data''', (tester) async {
      await bddSetUp(tester);
      await theresAnUpdateToAccountInformation(tester);
      await theAccountListShouldAutomaticallyRefreshWithTheLatestData(tester);
    });
    testWidgets('''Account balance visualization''', (tester) async {
      await bddSetUp(tester);
      await iViewAnAccountInTheList(tester);
      await iShouldSeeTheAccountsColorThemeAppliedToItsContainer(tester);
      await iShouldSeeTheAccountsIconDisplayed(tester);
    });
  });
}
