import 'dart:developer';

import 'package:hive_demo_todo/main.dart';
import 'package:hive_demo_todo/model/data_model.dart';
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

  Future updateNotes({required int index, required DataModel dataModel}) async {
    var data = await _notesBox.get('notes');
    if (data != null) {
      List fetchedlist = data;
      fetchedlist.removeAt(index);
      List newUpdatedList = fetchedlist;
      newUpdatedList.insert(index, dataModel);
      List finalList = newUpdatedList;
      await _notesBox.put('notes', finalList);
    } else {
      return;
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
