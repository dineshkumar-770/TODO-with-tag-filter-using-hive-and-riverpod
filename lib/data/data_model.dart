// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:hive/hive.dart';

part 'data_model.g.dart';

@HiveType(typeId: 0)
class DataModel {
  @HiveField(0)
  String? tag;

  @HiveField(1)
  String? title;

  @HiveField(2)
  String? description;
  
  DataModel({
    this.tag,
    this.title,
    this.description,
  });
  
  
}
