// To parse this JSON data, do
//
//     final apply = applyFromJson(jsonString);

import 'dart:convert';

Apply applyFromJson(String str) => Apply.fromJson(json.decode(str));

String applyToJson(Apply data) => json.encode(data.toJson());

class Apply {
  String userId;
  String userProfileId;
  String recruitmentId;
  String recruitmentName;
  String companyId;
  String comment;
  int statusApply;
  DateTime createdAt;
  DateTime updatedAt;
  String id;

  Apply({
    required this.userId,
    required this.userProfileId,
    required this.recruitmentId,
    required this.recruitmentName,
    required this.companyId,
    required this.comment,
    required this.statusApply,
    required this.createdAt,
    required this.updatedAt,
    required this.id,
  });

  factory Apply.fromJson(Map<String, dynamic> json) => Apply(
        userId: json["user_id"],
        userProfileId: json["user_profile_id"],
        recruitmentId: json["recruitment_id"],
        recruitmentName: json["recruitment_name"] ?? "",
        companyId: json["company_id"],
        comment: json["comment"],
        statusApply: json["status_apply"],
        createdAt: DateTime.parse(json["createdAt"]),
        updatedAt: DateTime.parse(json["updatedAt"]),
        id: json["id"],
      );

  Map<String, dynamic> toJson() => {
        "user_id": userId,
        "user_profile_id": userProfileId,
        "recruitment_id": recruitmentId,
        "recruitment_name": recruitmentName,
        "company_id": companyId,
        "comment": comment,
        "status_apply": statusApply,
        "createdAt": createdAt.toIso8601String(),
        "updatedAt": updatedAt.toIso8601String(),
        "id": id,
      };
}
