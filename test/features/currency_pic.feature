Feature: Currency Selection

  As a user of the FinTracker app
  I want to be able to select a currency
  So that I can use the app with my preferred currency

  Background:
    Given I am on the currency selection screen

  Scenario: Viewing available currencies
    Then I should see a list of available currencies
    And each currency should display its name, code, and symbol

  Scenario: Searching for a currency
    When I enter a search term in the search field
    Then the list should filter to show only matching currencies

  Scenario: Selecting a currency
    When I tap on a currency
    Then the selected currency should be visually highlighted

  Scenario: Proceeding with selected currency
    Given I have selected a currency
    When I tap the "Next" button
    Then the app should update to use the selected currency
    And I should be taken to the next screen

  Scenario: Attempting to proceed without selecting a currency
    Given I have not selected any currency
    When I tap the "Next" button
    Then I should see an error message asking me to select a currency

  Scenario: Resetting the database after currency selection
    Given I have selected a currency
    When I tap the "Next" button
    Then the app should reset the database

  Scenario: Displaying current currency selection
    Given I have previously selected a currency
    When I return to the currency selection screen
    Then my previously selected currency should be highlighted
