// To parse this JSON data, do
//
//     final profile = profileFromJson(jsonString);

import 'dart:convert';

Profile profileFromJson(String str) => Profile.fromJson(json.decode(str));

String profileToJson(Profile data) => json.encode(data.toJson());

class Profile {
  String userId;
  String name;
  String? pathCv;
  DateTime createdAt;
  DateTime updatedAt;
  String id;

  Profile({
    required this.userId,
    required this.name,
    required this.pathCv,
    required this.createdAt,
    required this.updatedAt,
    required this.id,
  });

  factory Profile.fromJson(Map<String, dynamic> json) => Profile(
        userId: json["user_id"],
        name: json["name"],
        pathCv: json["path_cv"] ?? '',
        createdAt: DateTime.parse(json["createdAt"]),
        updatedAt: DateTime.parse(json["updatedAt"]),
        id: json["id"],
      );

  Map<String, dynamic> toJson() => {
        "user_id": userId,
        "name": name,
        "path_cv": pathCv,
        "createdAt": createdAt.toIso8601String(),
        "updatedAt": updatedAt.toIso8601String(),
        "id": id,
      };
}
