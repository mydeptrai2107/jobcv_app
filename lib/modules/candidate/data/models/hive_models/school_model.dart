import 'package:hive_flutter/hive_flutter.dart';

@HiveType(typeId: 1)
class SchoolModel extends HiveObject {
  @HiveField(0)
  String nameSchool;

  @HiveField(1)
  DateTime to;

  @HiveField(2)
  DateTime from;

  @HiveField(3)
  String major;

  @HiveField(4)
  String description;

  SchoolModel(
      {required this.nameSchool,
      required this.to,
      required this.from,
      required this.major,
      required this.description});
}
