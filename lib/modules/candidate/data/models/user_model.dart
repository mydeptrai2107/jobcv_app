// To parse this JSON data, do
//
//     final user = userFromJson(jsonString);

import 'dart:convert';

UserModel userFromJson(String str) => UserModel.fromJson(json.decode(str));

String userToJson(UserModel data) => json.encode(data.toJson());

class UserModel {
  String userId;
  String accountId;
  String email;
  String firstName;
  String lastName;
  String? phone;
  String? gender;
  String? avatar;

  UserModel({
    required this.userId,
    required this.accountId,
    required this.email,
    required this.firstName,
    required this.lastName,
    this.phone,
    this.gender,
    this.avatar,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
        userId: json["userId"],
        accountId: json["accountId"],
        email: json["email"],
        firstName: json["firstName"],
        lastName: json["lastName"],
        phone: json["phone"] ?? '',
        gender: json["gender"] ?? '',
        avatar: json["avatar"] ?? '',
      );

  Map<String, dynamic> toJson() => {
        "userId": userId,
        "accountId": accountId,
        "email": email,
        "firstName": firstName,
        "lastName": lastName,
        "phone": phone,
        "gender": gender,
        "avatar": avatar,
      };
}
