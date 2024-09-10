// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: unused_import, directives_ordering

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'steps/settings_steps/step/i_am_on_the_settings_screen.dart';
import 'steps/settings_steps/step/i_tap_on_the_name_option.dart';
import 'steps/settings_steps/step/i_enter_a_new_name_john_doe.dart';
import 'steps/settings_steps/step/i_tap_the_save_button.dart';
import 'steps/settings_steps/step/my_name_should_be_updated_to_john_doe.dart';
import 'steps/settings_steps/step/i_tap_on_the_currency_option.dart';
import 'steps/settings_steps/step/i_select_a_new_currency_eur.dart';
import 'steps/settings_steps/step/the_app_currency_should_be_updated_to_eur.dart';
import 'steps/settings_steps/step/i_tap_on_the_export_option.dart';
import 'steps/settings_steps/step/i_confirm_the_export_action.dart';
import 'steps/settings_steps/step/my_app_data_should_be_exported_to_a_file.dart';
import 'steps/settings_steps/step/i_should_see_a_success_message_with_the_file_location.dart';
import 'steps/settings_steps/step/i_tap_on_the_import_option.dart';
import 'steps/settings_steps/step/i_select_a_valid_backup_file.dart';
import 'steps/settings_steps/step/i_confirm_the_import_action.dart';
import 'steps/settings_steps/step/the_app_data_should_be_replaced_with_the_imported_data.dart';
import 'steps/settings_steps/step/i_should_see_a_success_message.dart';
import 'steps/settings_steps/step/i_should_see_my_current_name.dart';
import 'steps/settings_steps/step/i_should_see_my_current_currency.dart';
import 'steps/settings_steps/step/i_should_see_options_for_export_and_import.dart';

void main() {
  group('''User Settings Management''', () {
    testWidgets('''Update user name''', (tester) async {
      await iAmOnTheSettingsScreen(tester);
      await iTapOnTheNameOption(tester);
      await iEnterANewNameJohnDoe(tester);
      await iTapTheSaveButton(tester);
      await myNameShouldBeUpdatedToJohnDoe(tester);
    });
    testWidgets('''Change app currency''', (tester) async {
      await iAmOnTheSettingsScreen(tester);
      await iTapOnTheCurrencyOption(tester);
      await iSelectANewCurrencyEur(tester);
      await theAppCurrencyShouldBeUpdatedToEur(tester);
    });
    testWidgets('''Export app data''', (tester) async {
      await iAmOnTheSettingsScreen(tester);
      await iTapOnTheExportOption(tester);
      await iConfirmTheExportAction(tester);
      await myAppDataShouldBeExportedToAFile(tester);
      await iShouldSeeASuccessMessageWithTheFileLocation(tester);
    });
    testWidgets('''Import app data''', (tester) async {
      await iAmOnTheSettingsScreen(tester);
      await iTapOnTheImportOption(tester);
      await iSelectAValidBackupFile(tester);
      await iConfirmTheImportAction(tester);
      await theAppDataShouldBeReplacedWithTheImportedData(tester);
      await iShouldSeeASuccessMessage(tester);
    });
    testWidgets('''View current settings''', (tester) async {
      await iAmOnTheSettingsScreen(tester);
      await iShouldSeeMyCurrentName(tester);
      await iShouldSeeMyCurrentCurrency(tester);
      await iShouldSeeOptionsForExportAndImport(tester);
    });
  });
}
