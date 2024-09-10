Feature: Application Initialization and Launch

  Scenario: Launching the application
    Given the Flutter binding is initialized
    And the database instance is obtained
    And the initial app state is retrieved
    When the application is launched
    Then the App widget should be rendered
    And the AppCubit should be provided with the initial app state
    And the App should be wrapped in a MultiBlocProvider

  Scenario: AppCubit initialization
    Given the initial app state is available
    When the AppCubit is created
    Then it should be initialized with the provided app state

  Scenario: MultiBlocProvider setup
    Given the application is being initialized
    When the MultiBlocProvider is configured
    Then it should include the AppCubit provider
    And it should wrap the App widget

  Scenario: Database initialization
    Given the application is starting
    When the getDBInstance function is called
    Then the database instance should be successfully obtained
    And it should be ready for use in the application
