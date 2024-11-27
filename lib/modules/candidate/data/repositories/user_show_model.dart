// To parse this JSON data, do
//
//     final userShow = userShowFromJson(jsonString);

import 'dart:convert';

UserShow userShowFromJson(String str) => UserShow.fromJson(json.decode(str));

String userShowToJson(UserShow data) => json.encode(data.toJson());

class UserShow {
    String firstName;
    String lastName;
    DateTime createdAt;
    DateTime updatedAt;
    String ? phone;
    String ? gender;
    String ? avatar;
    String id;

    UserShow({
        required this.firstName,
        required this.lastName,
        required this.createdAt,
        required this.updatedAt,
        required this.phone,
        required this.gender,
        required this.avatar,
        required this.id,
    });

    factory UserShow.fromJson(Map<String, dynamic> json) => UserShow(
        firstName: json["first_name"],
        lastName: json["last_name"],
        createdAt: DateTime.parse(json["createdAt"]),
        updatedAt: DateTime.parse(json["updatedAt"]),
        phone: json["phone"],
        gender: json["gender"],
        avatar: json["avatar"],
        id: json["id"],
    );

    Map<String, dynamic> toJson() => {
        "first_name": firstName,
        "last_name": lastName,
        "createdAt": createdAt.toIso8601String(),
        "updatedAt": updatedAt.toIso8601String(),
        "phone": phone,
        "gender": gender,
        "avatar": avatar,
        "id": id,
    };
}
