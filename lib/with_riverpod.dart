import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_demo_todo/data/data_model.dart';
import 'package:hive_demo_todo/hive_database.dart';
import 'package:hive_demo_todo/provider/provider.dart';

class WithRiverpod extends StatefulWidget {
  const WithRiverpod({super.key});

  @override
  State<WithRiverpod> createState() => _WithRiverpodState();
}

class _WithRiverpodState extends State<WithRiverpod> {
  late HiveDataBase _hiveDataBase;

  TextEditingController titleController = TextEditingController();
  TextEditingController desController = TextEditingController();

  String? popUpDropDownValue;
  String? mainDropDownValue;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _hiveDataBase = HiveDataBase();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                title: const Text('ADD'),
                content: Column(children: [
                  Consumer(builder: (context, ref, child) {
                    String ddValue = ref.watch(popUpTagSelector.notifier).state;
                    return DropdownButtonFormField(
                      hint: Text(popUpDropDownValue ?? 'Select Tag'),
                      onTap: () {
                        popUpDropDownValue = ddValue;
                      },
                      items: <String>['😎', '😍', '🥶', '🤬', '🫡']
                          .map((value) => DropdownMenuItem(
                              value: value, child: Text(value)))
                          .toList(),
                      onChanged: (value) {
                        ddValue = value!;
                        popUpDropDownValue = ddValue;
                        ref.refresh(popUpTagSelector.notifier).state;
                      },
                    );
                  }),
                  TextField(
                    controller: titleController,
                    decoration: const InputDecoration(
                        hintText: 'Title', label: Text('Title')),
                  ),
                  TextField(
                    controller: desController,
                    decoration: const InputDecoration(
                        hintText: 'Description', label: Text('Description')),
                  ),
                  const Spacer(),
                  Consumer(builder: (context, ref, child) {
                    return ElevatedButton(
                        onPressed: () async {
                          DataModel dbData = DataModel(
                              description: desController.text,
                              tag: popUpDropDownValue,
                              title: titleController.text);

                          _hiveDataBase
                              .addNotes(notesData: dbData)
                              .then((value) {
                            ref.refresh(notesProvider).value;
                          });
                          desController.clear();
                          titleController.clear();
                          Navigator.pop(context);
                        },
                        child: const Text('Add'));
                  })
                ]),
              );
            },
          );
        },
        child: const Icon(Icons.add),
      ),
      body: SafeArea(
        child: Consumer(
          builder: (context, ref, child) {
            final dataDp = ref.watch(notesProvider);
            String dropDownValue = ref.watch(tagSelector.notifier).state;
            return dataDp.when(
              data: (data) {
                print('>>>>>>>>>>>>>${data.length}');
                return Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: DropdownButtonFormField(
                        hint: Text(mainDropDownValue ?? 'All'),
                        items: <String>[
                          'All',
                          'Cool',
                          'Sexy',
                          'Chill',
                          'Angry',
                          'Fucker'
                        ]
                            .map((value) => DropdownMenuItem(
                                value: value, child: Text(value)))
                            .toList(),
                        onChanged: (value) {
                          dropDownValue = value!;
                          mainDropDownValue = dropDownValue;
                          ref.refresh(popUpTagSelector.notifier).state;
                        },
                      ),
                    ),
                    data.isEmpty
                        ? const Center(
                            child:
                                Text('Nothing to Show! Go and add something'),
                          )
                        : Expanded(
                            child: ListView.builder(
                              itemCount: data.length,
                              itemBuilder: (context, index) {
                                return ListTile(
                                  leading: CircleAvatar(
                                    child: Center(
                                      child: Text(data[index].tag.toString()),
                                    ),
                                  ),
                                  title: Text(data[index].title),
                                  subtitle:
                                      Text(data[index].description.toString()),
                                  trailing: IconButton(
                                      onPressed: () {
                                        _hiveDataBase
                                            .deleteData(index: index)
                                            .then((value) =>
                                                ref.refresh(notesProvider));
                                      },
                                      icon: Icon(Icons.delete)),
                                );
                              },
                            ),
                          ),
                  ],
                );
              },
              error: (error, stackTrace) {
                return const Center(child: Text('error'));
              },
              loading: () {
                return const Center(child: Text('Loading'));
              },
            );
          },
        ),
      ),
    );
  }
}
