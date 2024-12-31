import 'package:fintracker/model/account.model.dart';
import 'package:fintracker/model/category.model.dart';
import 'package:flutter/material.dart';

Account defaultAccount() {
  return Account(
    id: null,
    name: "Default Account",
    holderName: "Unknown",
    accountNumber: "Unknown",
    icon: Icons.account_balance,
    color: Colors.blue,
    isDefault: false,
    income: 0.0,
    expense: 0.0,
    balance: 0.0,
  );
}

Category defaultCategory() {
  return Category(
    id: null,
    name: "Default Category",
    icon: Icons.category,
    color: Colors.green,
  );
}
