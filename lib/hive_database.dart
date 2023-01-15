import 'dart:developer';

import 'package:hive_demo_todo/data/data_model.dart';
import 'package:hive_demo_todo/main.dart';
import 'package:hive_flutter/hive_flutter.dart';

class HiveDataBase {
  final _notesBox = Hive.box(boxName);

  Future addNotes({required DataModel notesData}) async {
    if (fetchNotes() != null) {
      List prevNotes = await fetchNotes();
      prevNotes.add(notesData);
      List updatedList = prevNotes;
      await _notesBox.put('notes', updatedList);
      log('Data list me daal diya');
    }
  }

  Future fetchNotes() async {
    var data = await _notesBox.get('notes');
    log(data.toString());
    return data;
  }

  Future deleteData({required int index}) async {
    List newList = await _notesBox.get('notes');
    newList.removeAt(index);
    List updatedList = newList;
    await _notesBox.put('notes', newList);
  }
}
