import 'package:hive/hive.dart';

@HiveType(typeId: 0)
class ExperienceModel extends HiveObject {
  @HiveField(0)
  String nameCompany;

  @HiveField(1)
  DateTime to;

  @HiveField(2)
  DateTime from;

  @HiveField(3)
  String position;

  @HiveField(4)
  String description;

  ExperienceModel(
      {required this.nameCompany,
      required this.to,
      required this.from,
      required this.position,
      required this.description});
}
