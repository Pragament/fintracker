Feature: Account Management Screen

  As a user of the FinTracker app
  I want to view and manage my accounts
  So that I can keep track of my financial information

  Background:
    Given I am on the Accounts Screen

  Scenario: View list of accounts
    When the screen loads
    Then I should see a list of my accounts
    And each account should display holder name, account name, masked account number, and balance

  Scenario: View account details
    When I look at an account in the list
    Then I should see the total balance, income, and expense for that account

  Scenario: Add a new account
    When I tap the floating action button
    Then the Account Form dialog should open
    And I should be able to enter details for a new account

  Scenario: Edit an existing account
    When I tap the more options button for an account
    And I select "Edit" from the menu
    Then the Account Form dialog should open with the account's current details
    And I should be able to modify the account information

  Scenario: Delete an account
    When I tap the more options button for an account
    And I select "Delete" from the menu
    Then a confirmation dialog should appear
    When I confirm the deletion
    Then the account should be removed from the list

  Scenario: Refresh account data
    When there's an update to account information
    Then the account list should automatically refresh with the latest data

  Scenario: Account balance visualization
    When I view an account in the list
    Then I should see the account's color theme applied to its container
    And I should see the account's icon displayed
