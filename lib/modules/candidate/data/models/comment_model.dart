// To parse this JSON data, do
//
//     final comment = commentFromJson(jsonString);

import 'dart:convert';

Comment commentFromJson(String str) => Comment.fromJson(json.decode(str));

String commentToJson(Comment data) => json.encode(data.toJson());

class Comment {
  String companyId;
  String userId;
  String comment;
  int rate;
  DateTime createdAt;
  DateTime updatedAt;
  String id;

  Comment({
    required this.companyId,
    required this.userId,
    required this.comment,
    required this.rate,
    required this.createdAt,
    required this.updatedAt,
    required this.id,
  });

  factory Comment.fromJson(Map<String, dynamic> json) => Comment(
        companyId: json["company_id"],
        userId: json["user_id"],
        comment: json["comment"],
        rate: json["rate"],
        createdAt: DateTime.parse(json["createdAt"]),
        updatedAt: DateTime.parse(json["updatedAt"]),
        id: json["id"],
      );

  Map<String, dynamic> toJson() => {
        "company_id": companyId,
        "user_id": userId,
        "comment": comment,
        "rate": rate,
        "createdAt": createdAt.toIso8601String(),
        "updatedAt": updatedAt.toIso8601String(),
        "id": id,
      };
}
