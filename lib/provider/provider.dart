import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_demo_todo/hive_database.dart';

final notesProvider = FutureProvider.autoDispose<List>((ref) async {
  return await HiveDataBase().fetchNotes() == null? [] : await HiveDataBase().fetchNotes();
});

final tagSelector = StateProvider<String>((ref) {
  return 'All';
});


final popUpTagSelector = StateProvider<String>((ref) {
  return 'All';
});