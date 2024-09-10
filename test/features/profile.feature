Feature: User Profile Screen

 Scenario: User opens the Profile screen
  Given the user has launched the app
  When the user navigates to the Profile screen
  Then the user should see a wallet icon
  And the user should see the message "Hi! welcome to Fintracker"
  And the user should see a text field labeled "Name"
  And the "Next" button should be visible


Scenario: User tries to proceed without entering a name
  Given the user is on the Profile screen
  When the user taps on the "Next" button without entering a name
  Then the user should see a message "Please enter your name"

Scenario: User enters their name and proceeds
  Given the user is on the Profile screen
  When the user enters text into the "Name" text field
  And the user taps on the "Next" button
  Then the user's name should be updated text field
  And the app should navigate to the next screen

