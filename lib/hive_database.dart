import 'dart:developer';

import 'package:hive_demo_todo/data/data_model.dart';
import 'package:hive_demo_todo/main.dart';
import 'package:hive_flutter/hive_flutter.dart';

class HiveDataBase {
  final _notesBox = Hive.box(boxName);

  Future addNotes({required DataModel notesData}) async {
    var data = await _notesBox.get('notes');
    if (data != null) {
      List prevNotes = data;
      prevNotes.add(notesData);
      List updatedList = prevNotes;
      await _notesBox.put('notes', updatedList);
      log('Data list me daal diya');
    } else {
      await _notesBox.put('notes', [notesData]);
    }
  }

  Future fetchNotes() async {
    var data = await _notesBox.get('notes');
    if (data != null) {
      log(data.toString());
      return data;
    } else {
      return [];
    }
  }

  Future deleteData({required int index}) async {
    var data = await _notesBox.get('notes');
    if (data != null) {
      List newList = data;
      newList.removeAt(index);
      List updatedList = newList;
      await _notesBox.put('notes', newList);
    }
  }
}

