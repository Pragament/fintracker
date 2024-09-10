Feature: FinTracker Home Screen

  Scenario: User views the home screen
    Given the user opens the FinTracker app
    Then they should see a greeting message
    And they should see their username or "Guest"

  Scenario: User views account information
    Given the user is on the home screen
    Then they should see an account slider
    And the slider should display account balances
    And the slider should show account holder names

  Scenario: User views payment summary
    Given the user is on the home screen
    Then they should see an income summary
    And they should see an expense summary

  Scenario: User views payment list
    Given the user is on the home screen
    Then they should see a list of recent payments
    And each payment should show category, date, and amount

  Scenario: User selects a date range
    Given the user is on the home screen
    When they tap on the date range button
    Then they should be able to select a custom date range
    And the payment list should update accordingly

  Scenario: User adds a new payment
    Given the user is on the home screen
    When they tap the floating action button
    Then they should be taken to the payment form screen

  Scenario: User taps on a payment
    Given the user is on the home screen
    When they tap on a payment in the list
    Then they should be taken to the payment form screen for that payment

  Scenario: User scrolls through accounts
    Given the user is on the home screen
    When they swipe on the account slider
    Then they should see different account cards
    And the indicator dots should update to show the current account
