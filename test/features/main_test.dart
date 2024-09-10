// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: unused_import, directives_ordering

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'steps/main_steps/step/the_flutter_binding_is_initialized.dart';
import 'steps/main_steps/step/the_database_instance_is_obtained.dart';
import 'steps/main_steps/step/the_initial_app_state_is_retrieved.dart';
import 'steps/main_steps/step/the_application_is_launched.dart';
import 'steps/main_steps/step/the_app_widget_should_be_rendered.dart';
import 'steps/main_steps/step/the_appcubit_should_be_provided_with_the_initial_app_state.dart';
import 'steps/main_steps/step/the_app_should_be_wrapped_in_a_multiblocprovider.dart';
import 'steps/main_steps/step/the_initial_app_state_is_available.dart';
import 'steps/main_steps/step/the_appcubit_is_created.dart';
import 'steps/main_steps/step/it_should_be_initialized_with_the_provided_app_state.dart';
import 'steps/main_steps/step/the_application_is_being_initialized.dart';
import 'steps/main_steps/step/the_multiblocprovider_is_configured.dart';
import 'steps/main_steps/step/it_should_include_the_appcubit_provider.dart';
import 'steps/main_steps/step/it_should_wrap_the_app_widget.dart';
import 'steps/main_steps/step/the_application_is_starting.dart';
import 'steps/main_steps/step/the_getdbinstance_function_is_called.dart';
import 'steps/main_steps/step/the_database_instance_should_be_successfully_obtained.dart';
import 'steps/main_steps/step/it_should_be_ready_for_use_in_the_application.dart';

void main() {
  group('''Application Initialization and Launch''', () {
    testWidgets('''Launching the application''', (tester) async {
      await theFlutterBindingIsInitialized(tester);
      await theDatabaseInstanceIsObtained(tester);
      await theInitialAppStateIsRetrieved(tester);
      await theApplicationIsLaunched(tester);
      await theAppWidgetShouldBeRendered(tester);
      await theAppcubitShouldBeProvidedWithTheInitialAppState(tester);
      await theAppShouldBeWrappedInAMultiblocprovider(tester);
    });
    testWidgets('''AppCubit initialization''', (tester) async {
      await theInitialAppStateIsAvailable(tester);
      await theAppcubitIsCreated(tester);
      await itShouldBeInitializedWithTheProvidedAppState(tester);
    });
    testWidgets('''MultiBlocProvider setup''', (tester) async {
      await theApplicationIsBeingInitialized(tester);
      await theMultiblocproviderIsConfigured(tester);
      await itShouldIncludeTheAppcubitProvider(tester);
      await itShouldWrapTheAppWidget(tester);
    });
    testWidgets('''Database initialization''', (tester) async {
      await theApplicationIsStarting(tester);
      await theGetdbinstanceFunctionIsCalled(tester);
      await theDatabaseInstanceShouldBeSuccessfullyObtained(tester);
      await itShouldBeReadyForUseInTheApplication(tester);
    });
  });
}
