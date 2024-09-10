Feature: Landing Page

  Scenario: Viewing the landing page
    Given the user opens the Fintracker app
    When the landing page loads
    Then the user should see the "Fintracker" title
    And the user should see the subtitle "Easy method to manage your savings"
    And the user should seeFeature: Landing Page for Fintracker App

  As a new user of the Fintracker app
  I want to see an informative landing page
  So that I can understand the app's purpose and get started

  Scenario: Viewing the Landing Page
    Given I am a new user opening the Fintracker app
    When I arrive at the landing page
    Then I should see the app name "Fintracker"
    And I should see the tagline "Easy method to manage your savings"
    And I should see 3 key features of the app
    And I should see a "Get Started" button

  Scenario: Starting the onboarding process
    Given I am on the landing page
    When I tap the "Get Started" button
    Then the onboarding process should begin

  Scenario: Verifying responsive layout
    Given I am on the landing page
    When I view the page on different screen sizes
    Then the layout should adjust appropriately
    And all elements should remain visible and properly aligned
 3 feature points with check icons
    And the user should see a beta disclaimer message
    And the user should see a "Get Started" button at the bottom

  Scenario: Starting the app journey
    Given the user is on the landing page
    When the user taps the "Get Started" button
    Then the app should proceed to the next screen

  Scenario: Adapting to app theme
    Given the app has a custom theme
    When the landing page loads
    Then the title should be in the primary color of the theme
    And the subtitle should be in a lighter shade of the primary color
    And the check icons should be in the primary color of the theme
    And the "Get Started" button should use the inversePrimary color of the theme

  Scenario: Responsive layout
    Given the app is opened on a device
    When the landing page loads
    Then all elements should be visible and properly aligned
    And the content should adjust to fit the screen size

  Scenario: Safe area compliance
    Given the device has a notch or rounded corners
    When the landing page loads
    Then all content should be within the safe area
    And no content should be obscured by device features

  Scenario: Accessibility
    Given the user has accessibility features enabled
    When the landing page loads
    Then all text should be readable by screen readers
    And all interactive elements should be focusable
    And the "Get Started" button should have appropriate contrast

  Scenario: Beta disclaimer visibility
    Given the user is on the landing page
    When the user scrolls to the bottom
    Then the beta disclaimer should be visible
    And it should warn about potential UI changes and unexpected behaviors
