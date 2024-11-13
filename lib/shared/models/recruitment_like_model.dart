// To parse this JSON data, do
//
//     final recruitmentLike = recruitmentLikeFromJson(jsonString);

import 'dart:convert';

import 'package:app/shared/models/recruitment_model.dart';

RecruitmentLike recruitmentLikeFromJson(String str) =>
    RecruitmentLike.fromJson(json.decode(str));

String recruitmentLikeToJson(RecruitmentLike data) =>
    json.encode(data.toJson());

class RecruitmentLike {
  Recruitment recruitment;
  int totalLike;

  RecruitmentLike({
    required this.recruitment,
    required this.totalLike,
  });

  factory RecruitmentLike.fromJson(Map<String, dynamic> json) =>
      RecruitmentLike(
        recruitment: Recruitment.fromJson(json["recruitment"]),
        totalLike: json["totalLike"],
      );

  Map<String, dynamic> toJson() => {
        "recruitment": recruitment.toJson(),
        "totalLike": totalLike,
      };
}
