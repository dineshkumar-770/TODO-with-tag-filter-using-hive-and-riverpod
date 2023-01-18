import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_demo_todo/services/hive_database.dart';
import 'package:intl/intl.dart';

final notesProvider = FutureProvider.autoDispose<List>((ref) async {
  return await HiveDataBase().fetchNotes() ?? [];
});

final tagSelector = StateProvider<String>((ref) {
  return 'All';
});

final popUpTagSelector = StateProvider<String>((ref) {
  return 'All';
});

final counterProvider = StreamProvider<int>((ref) {
  Stream<int> value = Stream.periodic(
    const Duration(seconds: 1),
    (x) => x-1,
  );
  return value;
});
