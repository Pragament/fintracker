Feature: User Settings Management

  As a user of the FinTracker app
  I want to manage my personal settings
  So that I can customize the app to my preferences

  Scenario: Update user name
    Given I am on the Settings screen
    When I tap on the Name option
    And I enter a new name "John Doe"
    And I tap the Save button
    Then my name should be updated to "John Doe"

  Scenario: Change app currency
    Given I am on the Settings screen
    When I tap on the Currency option
    And I select a new currency "EUR"
    Then the app currency should be updated to "EUR"

  Scenario: Export app data
    Given I am on the Settings screen
    When I tap on the Export option
    And I confirm the export action
    Then my app data should be exported to a file
    And I should see a success message with the file location

  Scenario: Import app data
    Given I am on the Settings screen
    When I tap on the Import option
    And I select a valid backup file
    And I confirm the import action
    Then the app data should be replaced with the imported data
    And I should see a success message

  Scenario: View current settings
    Given I am on the Settings screen
    Then I should see my current name
    And I should see my current currency
    And I should see options for Export and Import
