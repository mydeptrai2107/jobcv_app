// To parse this JSON data, do
//
//     final action = actionFromJson(jsonString);

import 'dart:convert';

ActionRecruitmentModel actionFromJson(String str) =>
    ActionRecruitmentModel.fromJson(json.decode(str));

String actionToJson(ActionRecruitmentModel data) => json.encode(data.toJson());

class ActionRecruitmentModel {
  String recruitmentId;
  String userId;
  bool isSaved;
  DateTime createdAt;
  DateTime updatedAt;
  String id;

  ActionRecruitmentModel({
    required this.recruitmentId,
    required this.userId,
    required this.isSaved,
    required this.createdAt,
    required this.updatedAt,
    required this.id,
  });

  factory ActionRecruitmentModel.fromJson(Map<String, dynamic> json) =>
      ActionRecruitmentModel(
        recruitmentId: json["recruitment_id"],
        userId: json["user_id"],
        isSaved: json["is_saved"],
        createdAt: DateTime.parse(json["createdAt"]),
        updatedAt: DateTime.parse(json["updatedAt"]),
        id: json["id"],
      );

  Map<String, dynamic> toJson() => {
        "recruitment_id": recruitmentId,
        "user_id": userId,
        "is_saved": isSaved,
        "createdAt": createdAt.toIso8601String(),
        "updatedAt": updatedAt.toIso8601String(),
        "id": id,
      };
}
