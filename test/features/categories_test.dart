// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: unused_import, directives_ordering

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'steps/categories_steps/step/i_am_on_the_categories_screen.dart';
import 'steps/categories_steps/step/the_screen_loads.dart';
import 'steps/categories_steps/step/i_should_see_a_list_of_my_expense_categories.dart';
import 'steps/categories_steps/step/each_category_should_display_its_name_icon_and_color.dart';
import 'steps/categories_steps/step/i_have_categories_with_budgets_set.dart';
import 'steps/categories_steps/step/i_look_at_a_category.dart';
import 'steps/categories_steps/step/i_should_see_a_progress_bar_indicating_the_expense_against_the_budget.dart';
import 'steps/categories_steps/step/i_have_a_category_without_a_budget_set.dart';
import 'steps/categories_steps/step/i_look_at_that_category.dart';
import 'steps/categories_steps/step/i_should_see_no_budget_displayed.dart';
import 'steps/categories_steps/step/i_tap_the_floating_action_button.dart';
import 'steps/categories_steps/step/a_category_form_dialog_should_appear.dart';
import 'steps/categories_steps/step/i_should_be_able_to_enter_details_for_a_new_category.dart';
import 'steps/categories_steps/step/i_tap_on_an_existing_category.dart';
import 'steps/categories_steps/step/i_should_be_able_to_edit_the_details_of_the_selected_category.dart';
import 'steps/categories_steps/step/i_have_made_changes_to_categories_elsewhere_in_the_app.dart';
import 'steps/categories_steps/step/i_return_to_the_categories_screen.dart';
import 'steps/categories_steps/step/the_list_should_automatically_update_to_reflect_the_changes.dart';
import 'steps/categories_steps/step/i_have_more_categories_than_fit_on_one_screen.dart';
import 'steps/categories_steps/step/i_scroll_the_list.dart';
import 'steps/categories_steps/step/i_should_be_able_to_see_all_categories_by_scrolling.dart';

void main() {
  group('''Categories Screen''', () {
    Future<void> bddSetUp(WidgetTester tester) async {
      await iAmOnTheCategoriesScreen(tester);
    }

    testWidgets('''View list of categories''', (tester) async {
      await bddSetUp(tester);
      await theScreenLoads(tester);
      await iShouldSeeAListOfMyExpenseCategories(tester);
      await eachCategoryShouldDisplayItsNameIconAndColor(tester);
    });
    testWidgets('''View category budget progress''', (tester) async {
      await bddSetUp(tester);
      await iHaveCategoriesWithBudgetsSet(tester);
      await iLookAtACategory(tester);
      await iShouldSeeAProgressBarIndicatingTheExpenseAgainstTheBudget(tester);
    });
    testWidgets('''View category without budget''', (tester) async {
      await bddSetUp(tester);
      await iHaveACategoryWithoutABudgetSet(tester);
      await iLookAtThatCategory(tester);
      await iShouldSeeNoBudgetDisplayed(tester);
    });
    testWidgets('''Add a new category''', (tester) async {
      await bddSetUp(tester);
      await iTapTheFloatingActionButton(tester);
      await aCategoryFormDialogShouldAppear(tester);
      await iShouldBeAbleToEnterDetailsForANewCategory(tester);
    });
    testWidgets('''Edit an existing category''', (tester) async {
      await bddSetUp(tester);
      await iTapOnAnExistingCategory(tester);
      await aCategoryFormDialogShouldAppear(tester);
      await iShouldBeAbleToEditTheDetailsOfTheSelectedCategory(tester);
    });
    testWidgets('''Real-time update of categories''', (tester) async {
      await bddSetUp(tester);
      await iHaveMadeChangesToCategoriesElsewhereInTheApp(tester);
      await iReturnToTheCategoriesScreen(tester);
      await theListShouldAutomaticallyUpdateToReflectTheChanges(tester);
    });
    testWidgets('''Scroll through categories''', (tester) async {
      await bddSetUp(tester);
      await iHaveMoreCategoriesThanFitOnOneScreen(tester);
      await iScrollTheList(tester);
      await iShouldBeAbleToSeeAllCategoriesByScrolling(tester);
    });
  });
}
