import 'package:fintracker/helpers/sharedpreferneceshelper.dart';
import 'package:fintracker/screens/settings/newrulescreen.dart';
import 'package:flutter/material.dart';

class AddUserSettingsScreen extends StatefulWidget {
  const AddUserSettingsScreen({super.key});

  @override
  State<AddUserSettingsScreen> createState() => _AddUserSettingsScreenState();
}

class _AddUserSettingsScreenState extends State<AddUserSettingsScreen> {
  List<String> listOfUserRules = [];
  Map<String, dynamic> listOfCategoryRules = {};

  @override
  void initState() {
    super.initState();
    setData();
  }

  setData() {
    listOfCategoryRules = SharedPreferncesHelper.getListOfCategoryRules();
    listOfUserRules = SharedPreferncesHelper.getListOfUserRules();
    setState(() {});
  }

  List listOfDefaultRules = [
    {
      "title": "Transportation",
      "items": ["Toll Charges", "Motors"]
    },
    {
      "title": "Food",
      "items": ["Food", "Swiggy", "Zomato", "Bistro", "Restaurant"]
    },
    {
      "title": "Medical",
      "items": ["Pharmacy", "Diagnostics"],
    },
    {
      "title": "Entertainment",
      "items": ["BookMyShow"]
    },
  ];

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "User Rules",
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(
              height: 15,
            ),
            Container(
              width: size.width * 0.9,
              child: const Text(
                "Default Rules",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 10),
              child: Card(
                elevation: 5,
                child: ListView.builder(
                    itemCount: listOfDefaultRules.length,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemBuilder: (context, index) {
                      final rule = listOfDefaultRules[index];
                      return Column(
                        children: [
                          Theme(
                            data: Theme.of(context)
                                .copyWith(dividerColor: Colors.transparent),
                            child: ExpansionTile(
                              expandedAlignment: Alignment.centerLeft,
                              expandedCrossAxisAlignment: CrossAxisAlignment.start,
                              title: Text(
                                rule['title'],style: const TextStyle(fontWeight: FontWeight.bold,fontSize: 18),
                              ),
                              children: (rule['items'] as List)
                                  .map(
                                    (item) => Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text(item,),
                                    ),
                                  )
                                  .toList(),
                            ),
                          ),
                          listOfDefaultRules.length-1 != index ? const Divider(
                            color: Colors.grey,
                            thickness: 1.5,
                          ) : const SizedBox(),
                        ],
                      );
                    }),
              ),
            ),
            const SizedBox(
              height: 15,
            ),
            Container(
              width: size.width * 0.9,
              child: const Text(
                "Your Rules",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 10),
              child: Card(
                elevation: 5,
                child: ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: listOfUserRules.length,
                    itemBuilder: (context, index) {
                      String title = listOfUserRules[index];
                      return ListTile(
                        title: Text(title,
                            style: Theme.of(context)
                                .textTheme
                                .bodyMedium
                                ?.merge(const TextStyle(
                                    fontWeight: FontWeight.w500,
                                    fontSize: 15))),
                        subtitle: Text(
                            "Category : ${listOfCategoryRules[title]}",
                            style: Theme.of(context).textTheme.bodySmall?.apply(
                                color: Colors.grey,
                                overflow: TextOverflow.ellipsis)),
                        trailing: IconButton(
                          icon: const Icon(
                            Icons.delete,
                            color: Colors.red,
                          ),
                          onPressed: () {
                            SharedPreferncesHelper.remove(title);
                            setData();
                          },
                        ),
                      );
                    }),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const NewRulesScreen(),
          ),
        ),
        child: const Icon(Icons.add),
      ),
    );
  }
}
