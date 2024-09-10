import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

/// Usage: the user enters "John Doe" into the "Name" text field

Future<void> theUserEntersNameIntoTheNameTextField(WidgetTester tester) async {
  final nameTextField = find.byKey(const Key('nameTextField'));
  //await tester.enterText(nameTextField, 'John Doe');
}

