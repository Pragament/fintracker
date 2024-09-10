// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: unused_import, directives_ordering

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'steps/profile_steps/step/the_user_has_launched_the_app.dart';
import 'steps/profile_steps/step/the_user_navigates_to_the_profile_screen.dart';
import 'steps/profile_steps/step/the_user_should_see_a_wallet_icon.dart';
import 'steps/profile_steps/step/the_user_should_see_the_message_hi_welcome_to_fintracker.dart';
import 'steps/profile_steps/step/the_user_should_see_a_text_field_labeled_name.dart';
import 'steps/profile_steps/step/the_next_button_should_be_visible.dart';
import 'steps/profile_steps/step/the_user_is_on_the_profile_screen.dart';
import 'steps/profile_steps/step/the_user_taps_on_the_next_button_without_entering_a_name.dart';
import 'steps/profile_steps/step/the_user_should_see_a_message_please_enter_your_name.dart';
import 'steps/profile_steps/step/the_user_enters_john_doe_into_the_name_text_field.dart';
import 'steps/profile_steps/step/the_user_taps_on_the_next_button.dart';
import 'steps/profile_steps/step/the_users_name_should_be_updated_to_john_doe.dart';
import 'steps/profile_steps/step/the_app_should_navigate_to_the_next_screen.dart';

void main() {
  group('''User Profile Screen''', () {
    testWidgets('''User opens the Profile screen''', (tester) async {
      await theUserHasLaunchedTheApp(tester);
      await theUserNavigatesToTheProfileScreen(tester);
      await theUserShouldSeeAWalletIcon(tester);
      await theUserShouldSeeATextFieldLabeledName(tester);
      await theNextButtonShouldBeVisible(tester);
    });
    testWidgets('''User tries to proceed without entering a name''',
        (tester) async {
      await theUserIsOnTheProfileScreen(tester);
      await theUserTapsOnTheNextButtonWithoutEnteringAName(tester);
      await theUserShouldSeeAMessagePleaseEnterYourName(tester);
    });
    testWidgets('''User enters their name and proceeds''', (tester) async {
      await theUserIsOnTheProfileScreen(tester);
      await theUserEntersNameIntoTheNameTextField(tester);
      await theUserTapsOnTheNextButton(tester);
      await theUsersNameShouldBeUpdatedToJohnDoe(tester);
      await theAppShouldNavigateToTheNextScreen(tester);
    });
  });
}
