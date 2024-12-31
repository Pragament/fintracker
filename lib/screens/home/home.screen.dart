import 'dart:io';
import 'package:csv/csv.dart';
import 'package:events_emitter/events_emitter.dart';
import 'package:file_picker/file_picker.dart';
import 'package:fintracker/bloc/cubit/app_cubit.dart';
import 'package:fintracker/dao/account_dao.dart';
import 'package:fintracker/dao/payment_dao.dart';
import 'package:fintracker/events.dart';
import 'package:fintracker/model/account.model.dart';
import 'package:fintracker/model/category.model.dart';
import 'package:fintracker/model/default_account.model.dart';
import 'package:fintracker/model/payment.model.dart';
import 'package:fintracker/screens/home/widgets/date_picker.dart';
import 'package:fintracker/screens/home/widgets/line_chart.dart';
import 'package:fintracker/screens/home/widgets/pie_chart.dart';
import 'package:fintracker/screens/home/widgets/account_slider.dart';
import 'package:fintracker/screens/home/widgets/payment_list_item.dart';
import 'package:fintracker/screens/payment_form.screen.dart';
import 'package:fintracker/theme/colors.dart';
import 'package:fintracker/widgets/currency.dart';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:easy_date_timeline/easy_date_timeline.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:share_plus/share_plus.dart';
import 'package:collection/collection.dart';

import '../../dao/tag_dao.dart';
import '../../model/tag.model.dart';

String greeting() {
  var hour = DateTime.now().hour;
  if (hour < 12) {
    return 'Morning';
  }
  if (hour < 17) {
    return 'Afternoon';
  }
  return 'Evening';
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final PaymentDao _paymentDao = PaymentDao();
  final AccountDao _accountDao = AccountDao();
  EventListener? _accountEventListener;
  EventListener? _categoryEventListener;
  EventListener? _paymentEventListener;
  EventListener? _tagEventListener;

  List<Payment> _payments = [];
  List<Account> _accounts = [];
  double _income = 0;
  double _expense = 0;
  List<double> _monthlyExpenses = List.generate(12, (index) => 0.0);
  Account? _selectedAccount;
  Category? _selectedCategory;

  List<Tag> tags = [];
  List<bool> selectedTags = [];
  final TagDao tagDao = TagDao();
  bool allSelected = true;

  //double _savings = 0;

  DateTime _focusDate = DateTime.now();

  DateTimeRange _range = DateTimeRange(
      start: DateTime.now().subtract(Duration(days: DateTime.now().day - 1)),
      end: DateTime.now());
  Account? _account;
  Category? _category;
  bool _showingIncomeOnly = false; // New state variable
  bool _showingExpenseOnly = false;
  String exportFormat = "Amount, Type";
  String importFormat = "Amount, Type";

  void openAddPaymentPage(PaymentType type) async {
    Navigator.of(context)
        .push(MaterialPageRoute(builder: (builder) => PaymentForm(type: type)));
  }

  void _updateDateRange(DateTimeRange newRange) {
    setState(() {
      _range = newRange;
      _fetchTransactions();
    });
  }

  void handleChooseDateRange() async {
    Navigator.of(context).push(MaterialPageRoute(
        builder: (builder) =>
            CustomCalender(updateDateRange: _updateDateRange)));
  }

  void _fetchTransactions() async {
    List<Payment> trans;

    // Fetch the selected tag IDs
    List<int> selectedTagIds = [];
    for (int i = 0; i < selectedTags.length; i++) {
      if (selectedTags[i]) {
        selectedTagIds.add(tags[i].id!);
      }
    }

    print("Selected tag IDs: $selectedTagIds");

    if (!allSelected && selectedTagIds.isNotEmpty) {
      // Fetch payments based on selected tags
      trans = await _paymentDao.findByTags(
        range: _range,
        tagIds: selectedTagIds,
        account: _selectedAccount ?? _account,
        category: _selectedCategory,
        type: _showingIncomeOnly
            ? PaymentType.debit
            : _showingExpenseOnly
                ? PaymentType.credit
                : null, // Filter by type (income/expense)
      );
      print("Fetched Payment: ${trans.length}");
    } else {
      // Filter based on showing income/expense only and selected account
      if (_selectedCategory == null) {
        trans = await _paymentDao.find(range: _range, category: _category);
      }
      if (_showingIncomeOnly) {
        trans = await _paymentDao.find(
          range: _range,
          type: PaymentType.debit,
          account: _selectedAccount ??
              _account, // Use the selected account (optional)
          category:
              _selectedCategory, // Filter by selected category (mandatory)
        );
      } else if (_showingExpenseOnly) {
        trans = await _paymentDao.find(
          range: _range,
          type: PaymentType.credit,
          account: _selectedAccount ??
              _account, // Use the selected account (optional)
          category:
              _selectedCategory, // Filter by selected category (mandatory)
        );
      } else {
        // If no filtering by income/expense
        if (_selectedCategory != null) {
          // Filter by category only if a category is selected
          trans = await _paymentDao.find(
            range: _range,
            category: _selectedCategory,
          );
        } else if (_selectedAccount != null) {
          // If no category selected, filter by account
          trans = await _paymentDao.find(
              range: _range,
              account: _selectedAccount // Use the selected account (optional)
              );
        } else {
          // If no filters applied, fetch all transactions (unchanged)
          trans = await _paymentDao.find(range: _range, category: _category);
        }
      }
    }

    double income = 0;
    double expense = 0;
    List<double> monthlyExpenses = List.generate(12, (index) => 0.0);
    for (var payment in trans) {
      if (payment.type == PaymentType.credit) income += payment.amount;
      if (payment.type == PaymentType.debit) {
        expense += payment.amount;
        DateTime paymentDate = payment.datetime;
        monthlyExpenses[paymentDate.month - 1] += payment.amount;
      }
    }

    // fetch accounts
    List<Account> accounts = await _accountDao.find(withSummery: true);

    setState(() {
      _payments = trans;
      _income = income;
      _expense = expense;
      _accounts = accounts;
      _monthlyExpenses = monthlyExpenses;
    });
  }

  void onAccountSelected(Account? account) {
    setState(() {
      _selectedAccount = account;

      _fetchTransactions();
    });
  }

  void onCategorySelected(Category? category) {
    setState(() {
      _selectedCategory = category;
      _fetchTransactions();
    });
  }

  Future<void> _fetchTags() async {
    final fetchedTags = await tagDao.findAll();
    setState(() {
      tags = fetchedTags;
      selectedTags = List<bool>.filled(tags.length, false);
    });
  }

  @override
  void initState() {
    super.initState();
    _fetchTransactions();
    _fetchTags();
    _accountEventListener = globalEvent.on("account_update", (data) {
      debugPrint("accounts are changed");
      _fetchTransactions();
    });

    _categoryEventListener = globalEvent.on("category_update", (data) {
      debugPrint("categories are changed");
      _fetchTransactions();
    });

    _paymentEventListener = globalEvent.on("payment_update", (data) {
      debugPrint("payments are changed");
      _fetchTransactions();
      _fetchTags();
    });

    _tagEventListener = globalEvent.on("tag_update", (data) {
      debugPrint("tags are updated");
      _fetchTags();
    });
  }

  @override
  void dispose() {
    _accountEventListener?.cancel();
    _categoryEventListener?.cancel();
    _paymentEventListener?.cancel();
    _tagEventListener?.cancel();
    super.dispose();
  }

  Future<void> _showExportOptions(BuildContext context) async {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Select Export Format"),
          content: StatefulBuilder(
            builder: (BuildContext context, StateSetter setState) {
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    ListTile(
                      title: const Text("Amount, Type"),
                      leading: Radio<String>(
                        value: "Amount, Type",
                        groupValue: exportFormat,
                        onChanged: (String? value) {
                          setState(() {
                            exportFormat =
                                value ?? "Amount, Type"; // Update export format
                          });
                        },
                      ),
                    ),
                    ListTile(
                      title: const Text("Debit, Credit"),
                      leading: Radio<String>(
                        value: "Debit, Credit",
                        groupValue: exportFormat,
                        onChanged: (String? value) {
                          setState(() {
                            exportFormat = value ??
                                "Debit, Credit"; // Update export format
                          });
                        },
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
          actions: [
            // Cancel Button
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: const Text("Cancel"),
            ),
            // Confirm Button
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
                exportToCSV(
                    context, exportFormat); // Confirm the selected format
              },
              child: const Text("Confirm"),
            ),
          ],
        );
      },
    );
  }

  Future<void> exportToCSV(BuildContext context, String exportFormat) async {
    try {
      final reversedPayments = List<Payment>.from(_payments.reversed);
      List<List<String>> csvData = [];

      // Add the header row based on the selected export format
      if (exportFormat == "Debit, Credit") {
        csvData.add([
          "ID",
          "Account Name",
          "Account Holder",
          "Account Number",
          "Category",
          "Debit",
          "Credit",
          "Date",
          "Title",
          "Description",
          "Auto Categorization"
        ]);
      } else {
        csvData.add([
          "ID",
          "Account Name",
          "Account Holder",
          "Account Number",
          "Category",
          "Amount",
          "Type",
          "Date",
          "Title",
          "Description",
          "Auto Categorization"
        ]);
      }

      // Add each payment's data
      for (var payment in reversedPayments) {
        if (exportFormat == "Debit, Credit") {
          csvData.add([
            payment.id?.toString() ?? '',
            payment.account.name,
            payment.account.holderName,
            payment.account.accountNumber,
            payment.category.name,
            payment.type == PaymentType.debit
                ? '-${payment.amount.toString()}'
                : '',
            payment.type == PaymentType.credit
                ? '+${payment.amount.toString()}'
                : '',
            payment.datetime.toIso8601String(),
            payment.title,
            payment.description,
            payment.autoCategorizationEnabled ? "Enabled" : "Disabled"
          ]);
        } else {
          csvData.add([
            payment.id?.toString() ?? '',
            payment.account.name,
            payment.account.holderName,
            payment.account.accountNumber,
            payment.category.name,
            payment.amount.toString(),
            payment.type.toString().split('.').last,
            payment.datetime.toIso8601String(),
            payment.title,
            payment.description,
            payment.autoCategorizationEnabled ? "Enabled" : "Disabled"
          ]);
        }
      }

      // Convert to CSV string
      String csv = const ListToCsvConverter().convert(csvData);

      // Get the directory to save the file
      Directory directory = await getApplicationDocumentsDirectory();
      final path =
          "/storage/emulated/0/Download/${reversedPayments[0].datetime.day}payments.csv";
      final file = File(path);
      await file.writeAsString(csv);

      // Show a dialog with preview of transactions and options for the user
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text("Export Options"),
            content: Column(
              children: [
                Text(
                    "New Transactions: ${reversedPayments.length}"), // Replace with actual filtered list count
                const Text(
                    "Updated Transactions: 0"), // Replace with actual filtered list count
                const Text(
                    "Local-Only Transactions: 0"), // Replace with actual filtered list count
                const SizedBox(height: 20),
                const Text(
                    "Would you like to download the CSV or share it via WhatsApp?"),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () async {
                  Navigator.of(context).pop();

                  // Open the file directly for the user to download it
                  final result = await OpenFile.open(file.path);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('CSV saved to: ${file.path}')),
                  );
                },
                child: const Text("Download"),
              ),
              TextButton(
                onPressed: () async {
                  // Open the file using XFile
                  final xfile = XFile(file.path);
                  // Share the file via WhatsApp
                  final result = await Share.shareXFiles([xfile],
                      text: "Here is the CSV file of Payment");
                  if (result.status == ShareResultStatus.success)
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Shared Successfully')),
                    );
                  await file.delete();
                  Navigator.of(context).pop(); // Close the dialog
                },
                child: const Text("Share to WhatsApp"),
              ),
            ],
          );
        },
      );
    } catch (e) {
      print("Error while exporting CSV: $e");
    }
  }

  Future<void> importPaymentsFromCSV(BuildContext context) async {
    try {
      String? selectedFormat = await _showImportFormatDialog(context);
      if (selectedFormat == null) return;

      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['csv'],
      );

      if (result != null && result.files.single.path != null) {
        File file = File(result.files.single.path!);
        final input = await file.readAsString();
        List<List<dynamic>> csvData = const CsvToListConverter().convert(input);

        List<Payment> parsedPayments = [];
        for (int i = 1; i < csvData.length; i++) {
          var row = csvData[i];
          Payment? payment;
          if (selectedFormat == "Amount, Type") {
            payment = Payment(
              id: null,
              account: defaultAccount(),
              category: defaultCategory(),
              amount: double.parse(row[0]?.toString() ?? '0.0'),
              type: row[1].toString().toLowerCase() == "credit"
                  ? PaymentType.credit
                  : PaymentType.debit,
              datetime: DateTime.now(),
              title: "Imported Payment",
              description: "",
              autoCategorizationEnabled: false,
            );
          } else if (selectedFormat == "Debit, Credit") {
            double debit = double.tryParse(row[0]?.toString() ?? '0.0') ?? 0.0;
            double credit = double.tryParse(row[1]?.toString() ?? '0.0') ?? 0.0;
            payment = Payment(
              id: null,
              account: defaultAccount(),
              category: defaultCategory(),
              amount: debit > 0 ? debit : credit,
              type: debit > 0 ? PaymentType.debit : PaymentType.credit,
              datetime: DateTime.now(),
              title: "Imported Payment",
              description: "",
              autoCategorizationEnabled: false,
            );
          }
          if (payment != null) parsedPayments.add(payment);
        }

        List<Payment> newTransactions = [];
        List<Payment> updatedTransactions = [];
        List<Payment> localOnlyTransactions = List.from(_payments);

        for (var csvPayment in parsedPayments) {
          Payment? match = _payments.firstWhereOrNull(
              (local) => csvPayment.datetime.isAtSameMomentAs(local.datetime));
          if (match != null) {
            updatedTransactions.add(csvPayment);
            localOnlyTransactions.remove(match);
          } else {
            newTransactions.add(csvPayment);
          }
        }

        bool? proceed = await _showImportSummaryDialog(
          context,
          newTransactions: newTransactions,
          updatedTransactions: updatedTransactions,
          localOnlyTransactions: localOnlyTransactions,
        );

        if (proceed == true) {
          bool? deleteLocal = await _confirmDeleteLocalTransactions(
            context,
            localOnlyTransactions.length,
          );

          setState(() {
            _payments.addAll(newTransactions);
            for (var updated in updatedTransactions) {
              _payments.removeWhere(
                  (local) => updated.datetime.isAtSameMomentAs(local.datetime));
              _payments.add(updated);
            }

            if (deleteLocal == true) {
              _payments.removeWhere(
                  (local) => localOnlyTransactions.contains(local));
            }
          });

          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Payments imported successfully!')),
          );
        }
      }
    } catch (e) {
      print("Error while importing CSV: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error importing CSV: $e')),
      );
    }
  }

  Future<bool?> _confirmDeleteLocalTransactions(
      BuildContext context, int count) {
    return showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Delete Local Transactions"),
        content: Text(
            "There are $count transactions in your local data that are not in the CSV file. Do you want to delete them?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text("No"),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text("Yes"),
          ),
        ],
      ),
    );
  }

  bool validateCSV(List<List<dynamic>> csvData) {
    if (csvData.isEmpty || csvData[0].length < 2) {
      return false; // Invalid structure
    }
    for (int i = 1; i < csvData.length; i++) {
      var row = csvData[i];
      if (row[0] == null || double.tryParse(row[0].toString()) == null) {
        return false; // Invalid amount
      }
      if (row[1] == null ||
          !["credit", "debit"].contains(row[1].toString().toLowerCase())) {
        return false; // Invalid type
      }
    }
    return true;
  }

  Future<bool?> _showImportSummaryDialog(
    BuildContext context, {
    required List<Payment> newTransactions,
    required List<Payment> updatedTransactions,
    required List<Payment> localOnlyTransactions,
  }) {
    return showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Import Summary"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text("New Transactions: ${newTransactions.length}"),
            Text("Updated Transactions: ${updatedTransactions.length}"),
            Text("Local-Only Transactions: ${localOnlyTransactions.length}"),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text("Cancel"),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text("Proceed"),
          ),
        ],
      ),
    );
  }

  Future<String?> _showImportFormatDialog(BuildContext context) async {
    String? importFormat = "Amount, Type"; // Default format

    return await showDialog<String>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Select Import Format"),
          content: SingleChildScrollView(
            child: StatefulBuilder(
              builder: (BuildContext context, StateSetter setState) {
                return Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    RadioListTile<String>(
                      title: const Text("Amount, Type"),
                      value: "Amount, Type",
                      groupValue: importFormat,
                      onChanged: (String? value) {
                        setState(() {
                          importFormat = value; // Update the state
                        });
                      },
                    ),
                    RadioListTile<String>(
                      title: const Text("Debit, Credit"),
                      value: "Debit, Credit",
                      groupValue: importFormat,
                      onChanged: (String? value) {
                        setState(() {
                          importFormat = value; // Update the state
                        });
                      },
                    ),
                  ],
                );
              },
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(null); // Cancel the dialog
              },
              child: const Text("Cancel"),
            ),
            ElevatedButton(
              onPressed: () {
                if (importFormat != null) {
                  Navigator.of(context).pop(importFormat); // Confirm selection
                } else {
                  // Optionally show a message if no format is selected
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                        content: Text('Please select an import format.')),
                  );
                }
              },
              child: const Text("Confirm"),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Home",
          style: TextStyle(fontWeight: FontWeight.w600, fontSize: 18),
        ),
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            const DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.blue,
              ),
              child: Text(
                'Menu',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                ),
              ),
            ),
            // Move the LocaleSelectorPopupMenu inside the Drawer
            ListTile(
              title: const Text('Import CSV File'),
              trailing: IconButton(
                icon: const Icon(Icons.upload_file), // Updated icon for clarity
                onPressed: () async {
                  // Call the import function and handle any further actions here
                  await importPaymentsFromCSV(context);
                },
              ),
              subtitle: const Text(
                'Select a CSV file in the supported format (Amount, Type or Debit, Credit).',
                style: TextStyle(fontSize: 12.0, color: Colors.grey),
              ),
            ),

            // Add other items if needed
          ],
        ),
      ),
      body: SingleChildScrollView(
          child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // TagsStrip(),
          _buildTagsStrip(context),
          Container(
            margin:
                const EdgeInsets.only(left: 15, right: 15, bottom: 15, top: 0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Hi! Good ${greeting()}"),
                BlocConsumer<AppCubit, AppState>(
                    listener: (context, state) {},
                    builder: (context, state) => Text(
                          state.username ?? "Guest",
                          style: const TextStyle(
                              fontSize: 18, fontWeight: FontWeight.w600),
                        ))
              ],
            ),
          ),
          AccountsSlider(
            accounts: _accounts,
            onAccountSelected: onAccountSelected,
          ),
          const SizedBox(
            height: 15,
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: Row(children: [
              const Text("Payments",
                  style: TextStyle(fontWeight: FontWeight.w600, fontSize: 17)),
              const Expanded(child: SizedBox()),
              MaterialButton(
                onPressed: () {
                  handleChooseDateRange();
                },
                height: double.minPositive,
                padding: EdgeInsets.zero,
                materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                child: Row(
                  children: [
                    Text(
                      "${DateFormat("dd MMM").format(_range.start)} - ${DateFormat("dd MMM").format(_range.end)}",
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                    const Icon(Icons.arrow_drop_down_outlined)
                  ],
                ),
              ),
            ]),
          ),

          /*

            Horizontal Date picker is added to select a single date

          */
          //TableEventsExample(),
          EasyInfiniteDateTimeLine(
            firstDate: DateTime(2023),
            focusDate: _focusDate,
            lastDate: DateTime.now(),
            showTimelineHeader: false,
            onDateChange: (selectedDate) {
              setState(() {
                _focusDate = selectedDate;
                _range = DateTimeRange(start: selectedDate, end: selectedDate);
                _fetchTransactions();
              });
            },
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                    child: InkWell(
                  onTap: () {
                    setState(() {
                      _showingIncomeOnly =
                          !_showingIncomeOnly; // Toggle showing income
                      _showingExpenseOnly = false; // Hide expense only
                      _fetchTransactions();
                    });
                  },
                  child: Container(
                      padding: const EdgeInsets.symmetric(
                          vertical: 14, horizontal: 16),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(18),
                        color: ThemeColors.success.withOpacity(0.2),
                      ),
                      child: SizedBox(
                        width: double.infinity,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text.rich(TextSpan(children: [
                              //TextSpan(text: TextStyle(color: ThemeColors.success)),
                              TextSpan(
                                  text: "Income",
                                  style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w600)),
                            ])),
                            const SizedBox(
                              height: 5,
                            ),
                            CurrencyText(
                              _income,
                              style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w700,
                                  color: ThemeColors.success),
                            )
                          ],
                        ),
                      )),
                )),
                const SizedBox(
                  width: 10,
                ),
                Expanded(
                    child: InkWell(
                  onTap: () {
                    setState(() {
                      _showingExpenseOnly =
                          !_showingExpenseOnly; // Toggle showing expense
                      _showingIncomeOnly = false; // Hide income only
                      _fetchTransactions();
                    });
                  },
                  child: Container(
                      padding: const EdgeInsets.symmetric(
                          vertical: 14, horizontal: 16),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(18),
                        color: ThemeColors.error.withOpacity(0.2),
                      ),
                      child: SizedBox(
                        width: double.infinity,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text.rich(TextSpan(children: [
                              //TextSpan(text: "▲", style: TextStyle(color: ThemeColors.error)),
                              TextSpan(
                                  text: "Expense",
                                  style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w600)),
                            ])),
                            const SizedBox(
                              height: 5,
                            ),
                            CurrencyText(
                              _expense,
                              style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w700,
                                  color: ThemeColors.error),
                            )
                          ],
                        ),
                      )),
                )),
              ],
            ),
          ),
          ExpensePieChart(
            key: ValueKey<DateTimeRange>(_range),
            onCategorySelected: onCategorySelected,
            range: _range,
          ),
          ExpenseLineChart(
            monthlyExpenses: _monthlyExpenses,
          ),
          _payments.isNotEmpty
              ? ListView.separated(
                  padding: EdgeInsets.zero,
                  physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemBuilder: (BuildContext context, index) {
                    return PaymentListItem(
                        payment: _payments[index],
                        onTap: () {
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (builder) => PaymentForm(
                                    type: _payments[index].type,
                                    payment: _payments[index],
                                  )));
                        });
                  },
                  separatorBuilder: (BuildContext context, int index) {
                    return Container(
                      width: double.infinity,
                      color: Colors.grey.withAlpha(25),
                      height: 1,
                      margin: const EdgeInsets.only(left: 75, right: 20),
                    );
                  },
                  itemCount: _payments.length,
                )
              : Container(
                  padding: const EdgeInsets.symmetric(vertical: 25),
                  alignment: Alignment.center,
                  child: const Text("No payments!"),
                ),
        ],
      )),
      /**
           * Buttons to add income and expense
           */
      floatingActionButton: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          const SizedBox(width: 10.0),
          FloatingActionButton(
            heroTag: "Share",
            onPressed: () => _showExportOptions(context),
            backgroundColor: ThemeColors.error,
            child: const Icon(Icons.share),
          ),
          const SizedBox(width: 16.0),
          FloatingActionButton(
            heroTag: "income",
            onPressed: () => openAddPaymentPage(PaymentType.debit),
            backgroundColor: ThemeColors.success,
            child: const Icon(Icons.add),
          ),
          const SizedBox(width: 10.0),
          FloatingActionButton(
            heroTag: "expense",
            onPressed: () => openAddPaymentPage(PaymentType.debit),
            backgroundColor: ThemeColors.error,
            child: const Icon(Icons.remove),
          ),
        ],
      ),
    );
  }

  void toggleAllTags() {
    setState(() {
      allSelected = !allSelected;
      selectedTags = List<bool>.filled(tags.length, allSelected);
      _fetchTransactions();
    });
  }

  void toggleTagSelection(int index, bool value) {
    setState(() {
      selectedTags[index] = value;
      allSelected = selectedTags.every((selected) => selected);
      _fetchTransactions();
    });
  }

  Widget _buildTagsStrip(BuildContext context) {
    return tags.isEmpty
        ? const SizedBox()
        : Column(
            children: [
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    Container(
                      margin: const EdgeInsets.symmetric(horizontal: 5),
                      padding: const EdgeInsets.all(7),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: Colors.black45)),
                      child: Row(
                        children: [
                          InkWell(
                            child: Icon(allSelected
                                ? Icons.check_box
                                : Icons.check_box_outline_blank),
                            onTap: () {
                              toggleAllTags();
                            },
                          ),
                          const Text(
                            'Select All',
                            style: TextStyle(fontSize: 16),
                          ),
                        ],
                      ),
                    ),
                    Row(
                      children: List.generate(tags.length, (index) {
                        final tag = tags[index];
                        return Container(
                          margin: const EdgeInsets.symmetric(horizontal: 5),
                          padding: const EdgeInsets.all(7),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(color: Colors.black45)),
                          child: Row(
                            children: [
                              InkWell(
                                child: Icon(selectedTags[index]
                                    ? Icons.check_box
                                    : Icons.check_box_outline_blank),
                                onTap: () {
                                  toggleTagSelection(
                                      index, !selectedTags[index] ?? false);
                                },
                              ),
                              Text(
                                tag.name,
                                style: const TextStyle(fontSize: 16),
                              ),
                            ],
                          ),
                        );
                      }),
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 10,
              ),
            ],
          );
  }
}
