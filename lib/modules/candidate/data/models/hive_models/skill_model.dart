import 'package:hive/hive.dart';

@HiveType(typeId: 2)
class SkillModel extends HiveObject {
  @HiveField(0)
  String nameSkill;

  @HiveField(1)
  String description;

  SkillModel({
    required this.nameSkill,
    required this.description,
  });
}
