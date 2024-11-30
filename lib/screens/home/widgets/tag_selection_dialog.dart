import 'package:fintracker/dao/tag_dao.dart';
import 'package:flutter/material.dart';

import '../../../events.dart';
import '../../../model/tag.model.dart';

class TagsSelectionDialog extends StatefulWidget {
  const TagsSelectionDialog({super.key, required this.selectedTags});
  final List<Tag> selectedTags;

  @override
  State<TagsSelectionDialog> createState() => _TagsSelectionDialogState();
}

class _TagsSelectionDialogState extends State<TagsSelectionDialog> {
  List<Tag> selectedTags = [];
  List<Tag> allTags = [];
  List<Tag> filteredTags = [];
  final TextEditingController searchController = TextEditingController();
  final TagDao tagDao = TagDao();

  @override
  void initState() {
    super.initState();
    selectedTags = widget.selectedTags;
    allTags = widget.selectedTags;
    loadTags();
  }

  /// Fetch tags from the database and update the state
  Future<void> loadTags() async {
    try {
      final fetchedTags = await tagDao.findAll();
      setState(() {
        allTags = fetchedTags;
      });
    } catch (e) {
      debugPrint("Error loading tags: $e");
    }
  }

  /// Save a new tag to the database
  void saveTag(Tag tag) async {
    try {
      var value = await tagDao.upsert(tag);
      print("Tags updated: ${value}");
      await loadTags();
      globalEvent.emit("tag_update");
    }catch(e) {
      print("Error Tag:  $e");
    }
  }


  @override
  Widget build(BuildContext context) {
    filteredTags = allTags.where((tag) {
      return tag.name.toLowerCase().contains(searchController.text.toLowerCase());
    }).toList();
    return SizedBox(
      height: 500,
      width: 400,
      child: AlertDialog(
        scrollable: true,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Select a Tag:',
              style: TextStyle(fontSize: 15),
            ),
            InkWell(
              onTap: () {
                final tagNameController = TextEditingController();
                final formKey = GlobalKey<FormState>();

                showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: const Text(
                      "Enter tag name",
                      textAlign: TextAlign.center,
                    ),
                    shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(20.0)),
                    ),
                    content: SizedBox(
                      height: 125,
                      child: Form(
                        key: formKey,
                        child: Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: TextFormField(
                                controller: tagNameController,
                                autofocus: true,
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Cannot be empty';
                                  }
                                  return null;
                                },
                                decoration: const InputDecoration(
                                  labelText: 'Tag name',
                                  prefixIcon: Icon(Icons.tag),
                                ),
                              ),
                            ),
                            ElevatedButton(
                              onPressed: () async {
                                if (formKey.currentState?.validate() ?? false) {
                                  final newTag = Tag(
                                    id: DateTime.now()
                                        .millisecondsSinceEpoch,
                                    name: tagNameController.text,
                                  );
                                  saveTag(newTag);
                                  Navigator.of(context).pop();
                                }
                              },
                              child: const Text('Create'),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              },
              child: const Text(
                "Create Tag +",
                style: TextStyle(fontSize: 15),
              ),
            ),
          ],
        ),
        content: Column(
          children: [
            // Search bar
            TextField(
              controller: searchController,
              onChanged: (value) {
                setState(() {});
              },
              decoration: InputDecoration(
                labelText: 'Search...',
              ),
            ),
            const SizedBox(height: 10,),
            filteredTags.isEmpty
                ? const Text('No tags exist.\nTap + icon to create a new tag.')
                : SizedBox(
              height: 250,
              child: SingleChildScrollView(
                child: Column(
                  children: List.generate(
                    filteredTags.length,
                        (index) {
                      final tag = filteredTags[index];

                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 4.0),
                        child: Material(
                          elevation: 2,
                          borderRadius: BorderRadius.circular(10),
                          color: Colors.grey[100],
                          child: Row(
                            children: [
                              Expanded(
                                child: CheckboxListTile(
                                  title: Text(
                                    "# ${tag.name}",
                                    style: const TextStyle(fontSize: 13),
                                  ),
                                  value: selectedTags.map((e) => e.id).contains(tag.id),
                                  onChanged: (enabled) => setState(
                                        () => enabled ?? false
                                        ? selectedTags.add(tag)
                                        : selectedTags.remove(tag),
                                  ),
                                ),
                              ),
                              IconButton(
                                  icon: const Icon(Icons.delete, color: Colors.red,),
                                  onPressed: () async {
                                    await tagDao.delete(tag.id!);
                                    loadTags();
                                    setState(() {});
                                  }
                              )
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
            ),
          ],
        ),
        actions: [
          FilledButton(
            onPressed: () => Navigator.of(context).pop(selectedTags),
            child: const Text('Done'),
          ),
        ],
      ),
    );
  }
}
