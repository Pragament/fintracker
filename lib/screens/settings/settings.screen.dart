import 'package:currency_picker/currency_picker.dart';
import 'package:file_picker/file_picker.dart';
import 'package:fintracker/bloc/cubit/app_cubit.dart';
import 'package:fintracker/helpers/color.helper.dart';
import 'package:fintracker/helpers/db.helper.dart';
import 'package:fintracker/widgets/buttons/button.dart';
import 'package:fintracker/widgets/dialog/confirm.modal.dart';
import 'package:fintracker/widgets/dialog/loading_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:material_symbols_icons/material_symbols_icons.dart';
import 'package:fintracker/screens/settings/adduserrules.dart';

import '../../dao/payment_dao.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  final PaymentDao _paymentDao = PaymentDao();
  bool isCategorizing = false;
  bool isCategorizingUsingRules = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    return Scaffold(
        appBar: AppBar(
          title: const Text(
            "Settings",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
          ),
        ),
        body: ListView(
          children: [
            ListTile(
              key: const Key('settings_name_option'),
              dense: true,
              onTap: () {
                showDialog(
                    context: context,
                    builder: (context) {
                      TextEditingController controller = TextEditingController(
                          text: context.read<AppCubit>().state.username);
                      return AlertDialog(
                        title: const Text(
                          "Profile",
                          style: TextStyle(
                              fontWeight: FontWeight.w600, fontSize: 18),
                        ),
                        content: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "What should we call you?",
                              style: theme.textTheme.bodyLarge!.apply(
                                  color: ColorHelper.darken(
                                      theme.textTheme.bodyLarge!.color!),
                                  fontWeightDelta: 1),
                            ),
                            const SizedBox(
                              height: 15,
                            ),
                            TextFormField(
                              key: const Key('name_input'),
                              controller: controller,
                              decoration: InputDecoration(
                                  label: const Text("Name"),
                                  hintText: "Enter your name",
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(15),
                                  ),
                                  contentPadding: const EdgeInsets.symmetric(
                                      vertical: 12, horizontal: 15)),
                            )
                          ],
                        ),
                        actions: [
                          Row(
                            children: [
                              Expanded(
                                  child: AppButton(
                                onPressed: () {
                                  if (controller.text.isEmpty) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                        const SnackBar(
                                            content:
                                                Text("Please enter name")));
                                  } else {
                                    context
                                        .read<AppCubit>()
                                        .updateUsername(controller.text);
                                    Navigator.of(context).pop();
                                  }
                                },
                                height: 45,
                                label: "Save",
                              ))
                            ],
                          )
                        ],
                      );
                    });
              },
              leading: const CircleAvatar(child: Icon(Symbols.person)),
              title: Text('Name',
                  style: Theme.of(context).textTheme.bodyMedium?.merge(
                      const TextStyle(
                          fontWeight: FontWeight.w500, fontSize: 15))),
              subtitle:
                  BlocBuilder<AppCubit, AppState>(builder: (context, state) {
                return Text(state.username!,
                    style: Theme.of(context).textTheme.bodySmall?.apply(
                        color: Colors.grey, overflow: TextOverflow.ellipsis));
              }),
            ),
            ListTile(
              key: const Key('settings_currency_option'),
              dense: true,
              onTap: () {
                showCurrencyPicker(
                    context: context,
                    onSelect: (Currency currency) {
                      context.read<AppCubit>().updateCurrency(currency.code);
                    });
              },
              leading:
                  BlocBuilder<AppCubit, AppState>(builder: (context, state) {
                Currency? currency =
                    CurrencyService().findByCode(state.currency!);
                return CircleAvatar(child: Text(currency!.symbol));
              }),
              title: Text('Currency',
                  style: Theme.of(context).textTheme.bodyMedium?.merge(
                      const TextStyle(
                          fontWeight: FontWeight.w500, fontSize: 15))),
              subtitle:
                  BlocBuilder<AppCubit, AppState>(builder: (context, state) {
                Currency? currency =
                    CurrencyService().findByCode(state.currency!);
                return Text(currency!.name,
                    style: Theme.of(context).textTheme.bodySmall?.apply(
                        color: Colors.grey, overflow: TextOverflow.ellipsis));
              }),
            ),
            ListTile(
              key: const Key('settings_export_option'),
              dense: true,
              onTap: () async {
                // Show format selection dialog before export
                String selectedFormat = await showDialog<String>(
                      context: context,
                      builder: (context) {
                        return AlertDialog(
                          title: const Text('Choose Export Format'),
                          content: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              ListTile(
                                title: const Text("Amount, Type"),
                                onTap: () {
                                  Navigator.of(context).pop("Amount, Type");
                                },
                              ),
                              ListTile(
                                title: const Text("Debit, Credit"),
                                onTap: () {
                                  Navigator.of(context).pop("Debit, Credit");
                                },
                              ),
                            ],
                          ),
                        );
                      },
                    ) ??
                    "Amount, Type"; // Default format if none selected

                // Proceed with the export confirmation
                ConfirmModal.showConfirmDialog(
                  context,
                  title: "Are you sure?",
                  content: const Text("Want to export all the data to a file?"),
                  onConfirm: () async {
                    Navigator.of(context).pop();

                    // Show loading modal
                    LoadingModal.showLoadingDialog(
                      context,
                      content: const Text("Exporting data, please wait..."),
                    );

                    try {
                      // Call the export function with selected format
                      String exportPath = await export(format: selectedFormat);

                      // Show success message with export path
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                            content:
                                Text("File has been saved in $exportPath")),
                      );
                    } catch (err) {
                      // Handle any errors during export
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                            content: Text(
                                "Something went wrong while exporting data")),
                      );
                    } finally {
                      // Hide loading modal after completion
                      Navigator.of(context).pop();
                    }
                  },
                  onCancel: () {
                    Navigator.of(context).pop(); // Close the dialog if canceled
                  },
                );
              },
              leading: const CircleAvatar(
                child: Icon(Symbols.download),
              ),
              title: Text(
                'Export',
                style: Theme.of(context).textTheme.bodyMedium?.merge(
                      const TextStyle(
                          fontWeight: FontWeight.w500, fontSize: 15),
                    ),
              ),
              subtitle: Text(
                "Export to file",
                style: Theme.of(context).textTheme.bodySmall?.apply(
                      color: Colors.grey,
                      overflow: TextOverflow.ellipsis,
                    ),
              ),
            ),

            ListTile(
              key: const Key('import_confirm_button'),
              dense: true,
              onTap: () async {
                await FilePicker.platform.pickFiles(
                    dialogTitle: "Pick file",
                    allowMultiple: false,
                    allowCompression: false,
                    type: FileType.custom,
                    allowedExtensions: ["json"]).then((pick) {
                  if (pick == null || pick.files.isEmpty) {
                    return ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text("Please select file")));
                  }
                  PlatformFile file = pick.files.first;
                  ConfirmModal.showConfirmDialog(context,
                      title: "Are you sure?",
                      content: const Text(
                          "All payment data, categories, and accounts will be erased and replaced with the information imported from the backup."),
                      onConfirm: () async {
                    Navigator.of(context).pop();
                    LoadingModal.showLoadingDialog(context,
                        content: const Text("Exporting data please wait"));
                    await import(file.path!).then((value) {
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                          content: Text("Successfully imported.")));
                      Navigator.of(context).pop();
                    }).catchError((err) {
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                          content: Text(
                              "Something went wrong while importing data")));
                    });
                  }, onCancel: () {
                    Navigator.of(context).pop();
                  });
                }).catchError((err) {
                  return ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                          content: Text(
                              "Something went wrong while importing data")));
                });
              },
              leading: const CircleAvatar(
                  child: Icon(
                Symbols.upload,
              )),
              title: Text('Import',
                  style: Theme.of(context).textTheme.bodyMedium?.merge(
                      const TextStyle(
                          fontWeight: FontWeight.w500, fontSize: 15))),
              subtitle: Text("Import from backup file",
                  style: Theme.of(context).textTheme.bodySmall?.apply(
                      color: Colors.grey, overflow: TextOverflow.ellipsis)),
            ),
            // ListTile(
            //   dense: true,
            //   onTap: () async {
            //     ConfirmModal.showConfirmDialog(
            //         context, title: "Are you sure?",
            //         content: const Text("After deleting data can't be recovered"),
            //         onConfirm: ()async{
            //           Navigator.of(context).pop();
            //           Navigator.of(context).pop();
            //           await context.read<AppCubit>().reset();
            //           await resetDatabase();
            //         },
            //         onCancel: (){
            //           Navigator.of(context).pop();
            //         }
            //     );
            //   },
            //   leading: CircleAvatar(
            //       backgroundColor: ThemeColors.error.withAlpha(90),
            //       child: const Icon(Symbols.device_reset,)
            //   ),
            //   title:  Text('Reset', style: Theme.of(context).textTheme.bodyMedium?.merge(const TextStyle(fontWeight: FontWeight.w500, fontSize: 15))),
            //   subtitle:  Text("Delete all the data",style: Theme.of(context).textTheme.bodySmall?.apply(color: Colors.grey, overflow: TextOverflow.ellipsis)),
            // ),

            ListTile(
              dense: true,
              onTap: () async {
                setState(() {
                  isCategorizing = true;
                });

                int count = await _paymentDao.updateMiscellanousCategories();

                //Categotization Result SnackBar
                if (count == 0) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text("No Payment left to categorize"),
                    ),
                  );
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text("Successfully Categorized $count Payments"),
                    ),
                  );
                }

                setState(() {
                  isCategorizing = false;
                });
              },
              leading: CircleAvatar(
                  child: isCategorizing
                      ? const Padding(
                          padding: EdgeInsets.all(8.0),
                          child: CircularProgressIndicator(),
                        )
                      : const Icon(
                          Icons.category,
                        )),
              title: Text('Categorize Miscellaneous Payments',
                  style: Theme.of(context).textTheme.bodyMedium?.merge(
                      const TextStyle(
                          fontWeight: FontWeight.w500, fontSize: 15))),
              subtitle: Text(
                  "Auto Categorize all Miscellaneous Category Payments",
                  style: Theme.of(context).textTheme.bodySmall?.apply(
                      color: Colors.grey, overflow: TextOverflow.ellipsis)),
            ),

            ListTile(
              dense: true,
              onTap: () async {
                setState(() {
                  isCategorizingUsingRules = true;
                });

                int count = await _paymentDao.categorizeUsingRules();

                //Categotization Result SnackBar
                if (count == 0) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text("No Payment left to categorize"),
                    ),
                  );
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text("Successfully Categorized $count Payments"),
                    ),
                  );
                }

                setState(() {
                  isCategorizingUsingRules = false;
                });
              },
              leading: CircleAvatar(
                  child: isCategorizingUsingRules
                      ? const Padding(
                          padding: EdgeInsets.all(8.0),
                          child: CircularProgressIndicator(),
                        )
                      : const Icon(
                          Icons.category,
                        )),
              title: Text('Categorize Payments using Rules',
                  style: Theme.of(context).textTheme.bodyMedium?.merge(
                      const TextStyle(
                          fontWeight: FontWeight.w500, fontSize: 15))),
              subtitle: Text("Auto Categorize Payments using rules",
                  style: Theme.of(context).textTheme.bodySmall?.apply(
                      color: Colors.grey, overflow: TextOverflow.ellipsis)),
            ),

            ListTile(
              dense: true,
              onTap: () async {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (builder) => AddUserSettingsScreen(),
                  ),
                );
              },
              leading: const CircleAvatar(
                  child: Icon(
                Icons.category,
              )),
              title: Text('Set Categorization Rules',
                  style: Theme.of(context).textTheme.bodyMedium?.merge(
                      const TextStyle(
                          fontWeight: FontWeight.w500, fontSize: 15))),
              subtitle: Text(
                  "Set Categorization Rules for Payments with Miscellanous Category",
                  style: Theme.of(context).textTheme.bodySmall?.apply(
                      color: Colors.grey, overflow: TextOverflow.ellipsis)),
            ),
          ],
        ));
  }
}
