import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_demo_todo/model/data_model.dart';
import 'package:hive_demo_todo/services/hive_database.dart';
import 'package:hive_demo_todo/provider/provider.dart';
import 'package:intl/intl.dart';

class WithRiverpod extends StatefulWidget {
  const WithRiverpod({super.key});

  @override
  State<WithRiverpod> createState() => _WithRiverpodState();
}

class _WithRiverpodState extends State<WithRiverpod> {
  late HiveDataBase _hiveDataBase;

  TextEditingController titleController = TextEditingController();
  TextEditingController desController = TextEditingController();
  TextEditingController tagController = TextEditingController();

  TextEditingController titleControllerEdit = TextEditingController();
  TextEditingController desControllerEdit = TextEditingController();
  TextEditingController tagControllerEdit = TextEditingController();

  String? popUpDropDownValue;
  String? mainDropDownValue;

  @override
  void initState() {
    super.initState();
    _hiveDataBase = HiveDataBase();
    mainDropDownValue = "All";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Stickey Notes'),
      ),
      backgroundColor: Colors.black,
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                title: const Text('ADD'),
                content: Column(children: [
                  TextField(
                    controller: tagController,
                    decoration: const InputDecoration(
                      hintText: 'Tag',
                      label: Text('Tag'),
                    ),
                  ),
                  TextField(
                    controller: titleController,
                    decoration: const InputDecoration(
                      hintText: 'Title',
                      label: Text('Title'),
                    ),
                  ),
                  TextField(
                    controller: desController,
                    maxLines: 8,
                    decoration: const InputDecoration(
                        hintText: 'Description', label: Text('Description')),
                  ),
                  const Spacer(),
                  Consumer(builder: (context, ref, child) {
                    return ElevatedButton(
                        onPressed: () async {
                          if (desController.text.isEmpty || tagController.text.isEmpty || titleController.text.isEmpty) {
                            final snackBar = SnackBar(
                              content: Text(
                                textAlign: TextAlign.center,
                                'Please fill all the fields!!',
                                style: Theme.of(context)
                                    .textTheme
                                    .headline6!
                                    .copyWith(
                                        color: Colors.yellow.shade200,
                                        fontSize: 15),
                              ),
                              backgroundColor: Colors.black,
                              duration: const Duration(seconds: 3),
                            );
                            ScaffoldMessenger.of(context).showSnackBar(snackBar);
                          } else {
                            DataModel dbData = DataModel(
                                description: desController.text,
                                tag: tagController.text,
                                title: titleController.text,
                                createdAt: DateTime.now());
                            _hiveDataBase
                                .addNotes(notesData: dbData)
                                .then((value) {
                              ref.refresh(notesProvider).value;
                            });
                            desController.clear();
                            titleController.clear();
                            tagController.clear();
                            Navigator.pop(context);
                          }
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
                final filteredData = data.where((item) =>
                        item.tag == mainDropDownValue || mainDropDownValue == "All").toList();
                return Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: DropdownButtonFormField(
                        dropdownColor: Colors.black,
                        hint: Text(
                          mainDropDownValue ?? 'All',
                          style: TextStyle(
                              color: Colors.yellow.shade400,
                              fontWeight: FontWeight.w600),
                        ),
                        items: (['All'] + List.generate(data.length, (index) => data[index].tag)).toSet().map((value) => DropdownMenuItem(
                                value: value,
                                child: Text(value,
                                  style: TextStyle(color: Colors.yellow.shade400,
                                      fontWeight: FontWeight.w600),
                                )))
                            .toList(),
                        onChanged: (value) {
                          dropDownValue = value.toString();
                          mainDropDownValue = dropDownValue;
                          ref.refresh(tagSelector.notifier).state =  value.toString();
                        },
                      ),
                    ),
                    // const GridViewOfNotes(),
                    const Divider(
                      endIndent: 20,
                      indent: 20,
                      thickness: 1.5,
                    ),
                    data.isEmpty
                        ? const Center(child: Text('Nothing to Show! Go and add something',
                              style: TextStyle(color: Colors.white),
                            ),
                          )
                        : Expanded(
                            child: ListView.separated(
                              separatorBuilder: (context, index) {
                                return const Divider(
                                  thickness: 2,
                                );
                              },
                              itemCount: filteredData.length,
                              itemBuilder: (context, index) {
                                return
                                  ListTile(
                                  onTap: () {
                                    showModalBottomSheet(
                                      backgroundColor: Colors.transparent,
                                      context: context,
                                      builder: (context) {
                                        return Container(
                                          width: double.infinity,
                                          decoration: BoxDecoration(
                                              color: Colors.yellow.shade100,
                                              borderRadius: const BorderRadius.only(
                                                      topLeft: Radius.circular(15),
                                                      topRight: Radius.circular(15))),
                                          child: Padding( padding: const EdgeInsets.all(8.0),
                                            child: SingleChildScrollView(
                                              child: Column(
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  Row(
                                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                    children: [
                                                      Text('#${filteredData[index].tag.toString()}',
                                                        style: Theme.of(context)
                                                            .textTheme
                                                            .displayMedium,
                                                      ),
                                                      IconButton(
                                                          onPressed: () {
                                                            titleControllerEdit.text = data[index].title.toString();
                                                            tagControllerEdit.text = data[index].tag.toString();
                                                            desControllerEdit.text = data[index].description.toString();
                                                            showDialog(
                                                              context: context,
                                                              builder: (context) {
                                                                return AlertDialog(
                                                                  title: const Text('EDIT'),
                                                                  content: Column(
                                                                      children: [
                                                                        TextField(
                                                                          controller: tagControllerEdit,
                                                                          decoration: const InputDecoration(
                                                                            hintText: 'Tag',
                                                                            label: Text('Tag'),
                                                                          ),
                                                                        ),
                                                                        TextFormField(
                                                                          controller: titleControllerEdit,
                                                                          decoration: const InputDecoration(
                                                                            hintText: 'Title',
                                                                            label: Text('Title'),
                                                                          ),
                                                                        ),
                                                                        TextField(
                                                                          controller: desControllerEdit,
                                                                          maxLines: 8,
                                                                          decoration: const InputDecoration(
                                                                              hintText: 'Description',
                                                                              label: Text('Description')),
                                                                        ),
                                                                        const Spacer(),
                                                                        Consumer(builder: (context, ref, child) {
                                                                          return ElevatedButton(
                                                                              onPressed: () async {
                                                                                DataModel dbData = DataModel(description: desControllerEdit.text, tag: tagControllerEdit.text, title: titleControllerEdit.text, createdAt: DateTime.now());
                                                                                _hiveDataBase.updateNotes(index: index, dataModel: dbData).then((value) {
                                                                                  ref.refresh(notesProvider).value;
                                                                                });
                                                                                desController.clear();
                                                                                titleController.clear();
                                                                                tagController.clear();
                                                                                Navigator.pop(context);
                                                                                Navigator.pop(context);
                                                                              },
                                                                              child: const Text('Save'));
                                                                        })
                                                                      ]),
                                                                );
                                                              },
                                                            );
                                                          },
                                                          icon: const Icon(
                                                              Icons.edit))
                                                    ],
                                                  ),
                                                  Text(filteredData[index].title,
                                                    textAlign: TextAlign.start,
                                                    style: Theme.of(context).textTheme.displaySmall!.copyWith(fontSize: 30),
                                                  ),
                                                  const Divider(
                                                    thickness: 1.5,
                                                  ),
                                                  SelectableText(filteredData[index].description.toString(),
                                                    style: Theme.of(context).textTheme.displaySmall!.copyWith(fontSize: 20),
                                                  ),
                                                  Text('Created on:- ${DateFormat('EEE, MMM dd yyyy At hh:mm aa').format(data[index].createdAt)}')
                                                ],
                                              ),
                                            ),
                                          ),
                                        );
                                      },
                                    );
                                  },
                                  leading: CircleAvatar(
                                    child: Center(
                                      child: Text(filteredData[index].tag.toString(),
                                        style: const TextStyle(fontSize: 25),
                                      ),
                                    ),
                                  ),
                                  title: Text(filteredData[index].title,
                                    style: TextStyle(
                                        color: Colors.yellow.shade400,
                                        fontWeight: FontWeight.w600),
                                  ),
                                  subtitle: Text(
                                    filteredData[index].description.toString().length <50?
                                    filteredData[index].description.toString():
                                    filteredData[index].description.toString().replaceRange(
                                                50,filteredData[index].description.toString().length,'...'),
                                    style: TextStyle(
                                        color: Colors.yellow.shade200,
                                        fontWeight: FontWeight.w400),
                                  ),
                                  trailing: IconButton(
                                      onPressed: () {
                                        _hiveDataBase.deleteData(index: index).then((value) {
                                          mainDropDownValue = "All";
                                          ref.refresh(notesProvider);
                                        });
                                      },
                                      icon: const Icon(
                                        Icons.delete,
                                        color: Colors.red,
                                      )),
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
