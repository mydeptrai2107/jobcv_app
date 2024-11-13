// To parse this JSON data, do
//
//     final actionCompanyModel = actionCompanyModelFromJson(jsonString);

import 'dart:convert';

ActionCompanyModel actionCompanyModelFromJson(String str) => ActionCompanyModel.fromJson(json.decode(str));

String actionCompanyModelToJson(ActionCompanyModel data) => json.encode(data.toJson());

class ActionCompanyModel {
    String companyId;
    String userId;
    bool isSaved;
    DateTime createdAt;
    DateTime updatedAt;
    String id;

    ActionCompanyModel({
        required this.companyId,
        required this.userId,
        required this.isSaved,
        required this.createdAt,
        required this.updatedAt,
        required this.id,
    });

    factory ActionCompanyModel.fromJson(Map<String, dynamic> json) => ActionCompanyModel(
        companyId: json["company_id"],
        userId: json["user_id"],
        isSaved: json["is_saved"],
        createdAt: DateTime.parse(json["createdAt"]),
        updatedAt: DateTime.parse(json["updatedAt"]),
        id: json["id"],
    );

    Map<String, dynamic> toJson() => {
        "company_id": companyId,
        "user_id": userId,
        "is_saved": isSaved,
        "createdAt": createdAt.toIso8601String(),
        "updatedAt": updatedAt.toIso8601String(),
        "id": id,
    };
}
