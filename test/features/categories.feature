Feature: Categories Screen

  As a user
  I want to view and manage my expense categories
  So that I can organize my finances effectively

  Background:
    Given I am on the Categories Screen

  Scenario: View list of categories
    When the screen loads
    Then I should see a list of my expense categories
    And each category should display its name, icon, and color

  Scenario: View category budget progress
    Given I have categories with budgets set
    When I look at a category
    Then I should see a progress bar indicating the expense against the budget

  Scenario: View category without budget
    Given I have a category without a budget set
    When I look at that category
    Then I should see "No budget" displayed

  Scenario: Add a new category
    When I tap the floating action button
    Then a category form dialog should appear
    And I should be able to enter details for a new category

  Scenario: Edit an existing category
    When I tap on an existing category
    Then a category form dialog should appear
    And I should be able to edit the details of the selected category

  Scenario: Real-time update of categories
    Given I have made changes to categories elsewhere in the app
    When I return to the Categories Screen
    Then the list should automatically update to reflect the changes

  Scenario: Scroll through categories
    Given I have more categories than fit on one screen
    When I scroll the list
    Then I should be able to see all categories by scrolling
