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
        account:
        _selectedAccount ?? _account,
        category: _selectedCategory,
        type: _showingIncomeOnly
            ? PaymentType.debit
            : _showingExpenseOnly
            ? PaymentType.credit
            : null,                        // Filter by type (income/expense)
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
          account:
          _selectedAccount ?? _account, // Use the selected account (optional)
          category: _selectedCategory, // Filter by selected category (mandatory)
        );
      } else if (_showingExpenseOnly) {
        trans = await _paymentDao.find(
          range: _range,
          type: PaymentType.credit,
          account:
          _selectedAccount ?? _account, // Use the selected account (optional)
          category: _selectedCategory, // Filter by selected category (mandatory)
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

  Future<void> exportToCSV(BuildContext context) async {
    try {
      // Reverse the payments list to ensure correct order
      final reversedPayments = List<Payment>.from(_payments.reversed);
      // List to hold the CSV data
      List<List<String>> csvData = [];
      // Add the header row
      // Add the header row
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
      // Add each payment's data
      for (var payment in reversedPayments) {
        csvData.add([
          payment.id?.toString() ?? '',
          payment.account.name, // Account name
          payment.account.holderName, // Account holder's name
          payment.account.accountNumber, // Account number
          payment.category.name, // Category name
          payment.amount.toString(),
          payment.type.toString().split('.').last, // Enum: credit or debit
          payment.datetime.toIso8601String(),
          payment.title,
          payment.description,
          payment.autoCategorizationEnabled ? "Enabled" : "Disabled"
        ]);
      }
      // Convert to CSV string
      String csv = const ListToCsvConverter().convert(csvData);
      // Get the directory to save the file
      Directory directory = await getApplicationDocumentsDirectory();
      final path = "/storage/emulated/0/Download/${reversedPayments[0].datetime.day}payments.csv";
      final file = File(path);
      await file.writeAsString(csv);
      // Show the dialog box to let the user choose an action
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("Export Options"),
            content: Text(
                "Would you like to download the CSV or share it via WhatsApp?"),
            actions: [
              TextButton(
                onPressed: () async {

                  Navigator.of(context).pop();

                  // Open the file directly for the user to download it
                  final result = await OpenFile.open(file.path);
                 //  print(result.message);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('CSV saved to: ${file.path}')
                    ),
                  );

                },
                child: Text("Download"),
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
                      SnackBar(content: Text('Shared Successfully')),
                    );
                  await file.delete();
                  Navigator.of(context).pop(); // Close the dialog
                },
                child: Text("Share to WhatsApp"),
              ),
            ],
          );
        },
      );
    } catch (e) {
      print("Error while exporting CSV: $e");
    }
  }

  // Function to import CSV data and map it to your Payment model
  Future<void> importPaymentsFromCSV(BuildContext context) async {
    try {
      // File picker to allow user to select CSV file
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['csv'], // CSV only
      );

      if (result != null && result.files.single.path != null) {
        //if file exist
        File file = File(result.files.single.path!);

        // Read the file contents
        final input = await file.readAsString();

        // Parse the CSV file
        List<List<dynamic>> csvData = const CsvToListConverter().convert(input);

        List<Payment> importedPayments = [];
        // Skip the header row and process the rest

        for (int i = 1; i < csvData.length; i++) {
          var row = csvData[i];
          // Map CSV data to Payment fields
          Payment payment = Payment(
            id: int.tryParse(row[0]?.toString() ?? ''),
            account: Account(
              id: null,
              // Assuming account ID isn't available in CSV, handle as needed
              name: row[1].toString(),
              holderName: row[2].toString(),
              accountNumber: row[3].toString(),
              icon: Icons.account_balance,
              // Assign a default icon
              color: Colors.blue,
              // Default color, adjust as necessary
              isDefault: false,
              income: 0.0,
              expense: 0.0,
              balance: 0.0,
            ),
            category: Category(
              id: null, // Assuming category ID isn't available in CSV
              name: row[4].toString(),
              icon: Icons.category, // Default icon
              color: Colors.green, // Default color, adjust as necessary
            ),
            amount: double.parse(row[5]?.toString() ?? '0.0'),
            type: row[6] == "credit" ? PaymentType.credit : PaymentType.debit,
            datetime: DateTime.parse(row[7]),
            title: row[8]?.toString() ?? '',
            description: row[9]?.toString() ?? '',
            autoCategorizationEnabled: row[10] == "Enabled" ? true : false,
          );
          importedPayments.add(payment);
        }
        // Now, do something with the imported payments (e.g., add to your current list)
        setState(() {
          _payments = importedPayments;
        });

        Navigator.of(context).pop();//pop the drawer
        // Show a confirmation message
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Payments imported successfully!')),
        );
      }
    } catch (e) {
      print("Error while importing CSV: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error importing CSV: $e')),
      );
    }
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
            DrawerHeader(
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
              title: Text('Import CSV File'),
              trailing: IconButton(
                icon: const Icon(Icons.help_outline),
                onPressed: () {
                  importPaymentsFromCSV(context);
                },
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
            onPressed: () => exportToCSV(context),
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
                    border: Border.all(color: Colors.black45)
                ),
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
                        border: Border.all(color: Colors.black45)
                    ),
                    child: Row(
                      children: [
                        InkWell(
                          child: Icon(selectedTags[index]
                              ? Icons.check_box
                              : Icons.check_box_outline_blank),
                          onTap: () {
                            toggleTagSelection(index, !selectedTags[index] ?? false);
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
            const SizedBox(height: 10,),
          ],
        );
  }
}
