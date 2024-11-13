import 'package:hive/hive.dart';

@HiveType(typeId: 3)
class UserModelHive extends HiveObject {
  @HiveField(0)
  String firstName;

  @HiveField(1)
  String lastName;

  @HiveField(2)
  String phone;

  @HiveField(3)
  String id;

  @HiveField(4)
  String gender;

  @HiveField(5)
  String avatar;

  UserModelHive(
      {required this.firstName,
      required this.lastName,
      required this.phone,
      required this.id,
      required this.gender,
      required this.avatar});
}
