import 'package:fintracker/bloc/cubit/app_cubit.dart';
import 'package:fintracker/screens/onboard/widgets/profile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';

/// Usage: the user should see a wallet icon
Future<void> theUserShouldSeeAWalletIcon(WidgetTester tester) async {
  await tester.pumpWidget(
    BlocProvider(
      create: (context) => AppCubit(AppState()),
      child: MaterialApp(
        home: ProfileWidget(
          onGetStarted: () {},
        ),
      ),
    ),
  );
  expect(find.byIcon(Icons.account_balance_wallet), findsOneWidget);
}
