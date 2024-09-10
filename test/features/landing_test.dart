// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: unused_import, directives_ordering

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'steps/landing_steps/step/the_user_opens_the_fintracker_app.dart';
import 'steps/landing_steps/step/the_landing_page_loads.dart';
import 'steps/landing_steps/step/the_user_should_see_the_fintracker_title.dart';
import 'steps/landing_steps/step/the_user_should_see_the_subtitle_easy_method_to_manage_your_savings.dart';
import 'steps/landing_steps/step/the_user_should_seefeature_landing_page_for_fintracker_app.dart';
import 'steps/landing_steps/step/i_am_a_new_user_opening_the_fintracker_app.dart';
import 'steps/landing_steps/step/i_arrive_at_the_landing_page.dart';
import 'steps/landing_steps/step/i_should_see_the_app_name_fintracker.dart';
import 'steps/landing_steps/step/i_should_see_the_tagline_easy_method_to_manage_your_savings.dart';
import 'steps/landing_steps/step/i_should_see3_key_features_of_the_app.dart';
import 'steps/landing_steps/step/i_should_see_a_get_started_button.dart';
import 'steps/landing_steps/step/i_am_on_the_landing_page.dart';
import 'steps/landing_steps/step/i_tap_the_get_started_button.dart';
import 'steps/landing_steps/step/the_onboarding_process_should_begin.dart';
import 'steps/landing_steps/step/i_view_the_page_on_different_screen_sizes.dart';
import 'steps/landing_steps/step/the_layout_should_adjust_appropriately.dart';
import 'steps/landing_steps/step/all_elements_should_remain_visible_and_properly_aligned.dart';
import 'steps/landing_steps/step/the_user_should_see_a_beta_disclaimer_message.dart';
import 'steps/landing_steps/step/the_user_should_see_a_get_started_button_at_the_bottom.dart';
import 'steps/landing_steps/step/the_user_is_on_the_landing_page.dart';
import 'steps/landing_steps/step/the_user_taps_the_get_started_button.dart';
import 'steps/landing_steps/step/the_app_should_proceed_to_the_next_screen.dart';
import 'steps/landing_steps/step/the_app_has_a_custom_theme.dart';
import 'steps/landing_steps/step/the_title_should_be_in_the_primary_color_of_the_theme.dart';
import 'steps/landing_steps/step/the_subtitle_should_be_in_a_lighter_shade_of_the_primary_color.dart';
import 'steps/landing_steps/step/the_check_icons_should_be_in_the_primary_color_of_the_theme.dart';
import 'steps/landing_steps/step/the_get_started_button_should_use_the_inverseprimary_color_of_the_theme.dart';
import 'steps/landing_steps/step/the_app_is_opened_on_a_device.dart';
import 'steps/landing_steps/step/all_elements_should_be_visible_and_properly_aligned.dart';
import 'steps/landing_steps/step/the_content_should_adjust_to_fit_the_screen_size.dart';
import 'steps/landing_steps/step/the_device_has_a_notch_or_rounded_corners.dart';
import 'steps/landing_steps/step/all_content_should_be_within_the_safe_area.dart';
import 'steps/landing_steps/step/no_content_should_be_obscured_by_device_features.dart';
import 'steps/landing_steps/step/the_user_has_accessibility_features_enabled.dart';
import 'steps/landing_steps/step/all_text_should_be_readable_by_screen_readers.dart';
import 'steps/landing_steps/step/all_interactive_elements_should_be_focusable.dart';
import 'steps/landing_steps/step/the_get_started_button_should_have_appropriate_contrast.dart';
import 'steps/landing_steps/step/the_user_scrolls_to_the_bottom.dart';
import 'steps/landing_steps/step/the_beta_disclaimer_should_be_visible.dart';
import 'steps/landing_steps/step/it_should_warn_about_potential_ui_changes_and_unexpected_behaviors.dart';

void main() {
  group('''Landing Page''', () {
    testWidgets('''Viewing the landing page''', (tester) async {
      await theUserOpensTheFintrackerApp(tester);
      await theLandingPageLoads(tester);
       theUserShouldSeeTheFintrackerTitle(tester);
      await theUserShouldSeeTheSubtitleEasyMethodToManageYourSavings(tester);
      await theUserShouldSeeFeatureLandingPageForFintrackerApp(tester);
    });
    testWidgets('''Viewing the Landing Page''', (tester) async {
      await iAmANewUserOpeningTheFintrackerApp(tester);
      await iArriveAtTheLandingPage(tester);
      iShouldSeeTheAppNameFintracker(tester);
      iShouldSeeTheTaglineEasyMethodToManageYourSavings(tester);
      await iShouldSee3KeyFeaturesOfTheApp(tester);
      await iShouldSeeAGetStartedButton(tester);
    });
    testWidgets('''Starting the onboarding process''', (tester) async {
      await iAmOnTheLandingPage(tester);
      await iTapTheGetStartedButton(tester);
      theOnboardingProcessShouldBegin(tester);
    });
    testWidgets('''Verifying responsive layout''', (tester) async {
      await iAmOnTheLandingPage(tester);
      await iViewThePageOnDifferentScreenSizes(tester);
       theLayoutShouldAdjustAppropriately(tester);
       allElementsShouldRemainVisibleAndProperlyAligned(tester);
      await theUserShouldSeeABetaDisclaimerMessage(tester);
      await theUserShouldSeeAGetStartedButtonAtTheBottom(tester);
    });
    testWidgets('''Starting the app journey''', (tester) async {
      await theUserIsOnTheLandingPage(tester);
      await theUserTapsTheGetStartedButton(tester);
      await theAppShouldProceedToTheNextScreen(tester);
    });
    testWidgets('''Adapting to app theme''', (tester) async {
      await theAppHasACustomTheme(tester);
      await theLandingPageLoads(tester);
       theTitleShouldBeInThePrimaryColorOfTheTheme(tester);
       theSubtitleShouldBeInALighterShadeOfThePrimaryColor(tester);
       theCheckIconsShouldBeInThePrimaryColorOfTheTheme(tester);
      await theGetStartedButtonShouldUseTheInverseprimaryColorOfTheTheme(
          tester);
    });
    testWidgets('''Responsive layout''', (tester) async {
      await theAppIsOpenedOnADevice(tester);
      await theLandingPageLoads(tester);
      await allElementsShouldBeVisibleAndProperlyAligned(tester);
       theContentShouldAdjustToFitTheScreenSize(tester);
    });
    testWidgets('''Safe area compliance''', (tester) async {
      await theDeviceHasANotchOrRoundedCorners(tester);
      await theLandingPageLoads(tester);
      await allContentShouldBeWithinTheSafeArea(tester);
      await noContentShouldBeObscuredByDeviceFeatures(tester);
    });
    testWidgets('''Accessibility''', (tester) async {
      await theUserHasAccessibilityFeaturesEnabled(tester);
      await theLandingPageLoads(tester);
      await allTextShouldBeReadableByScreenReaders(tester);
      await allInteractiveElementsShouldBeFocusable(tester);
      await theGetStartedButtonShouldHaveAppropriateContrast(tester);
    });
    testWidgets('''Beta disclaimer visibility''', (tester) async {
      await theUserIsOnTheLandingPage(tester);
      await theBetaDisclaimerShouldBeVisible(tester);
      await itShouldWarnAboutPotentialUiChangesAndUnexpectedBehaviors(tester);
    });
  });
}
