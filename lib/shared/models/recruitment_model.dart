// To parse this JSON data, do
//
//     final recruitment = recruitmentFromJson(jsonString);

import 'dart:convert';

Recruitment recruitmentFromJson(String str) =>
    Recruitment.fromJson(json.decode(str));

String recruitmentToJson(Recruitment data) => json.encode(data.toJson());

class Recruitment {
  String companyId;
  String? title;
  String? salary;
  DateTime? deadline;
  String? workingForm;
  String? numberOfRecruits;
  String? gender;
  String? experience;
  String? position;
  String? address;
  String? descriptionWorking;
  String? request;
  String? benefit;
  DateTime? createdAt;
  DateTime? updatedAt;
  String? id;
  bool? statusShow;
  bool? isActive;

  Recruitment(
      {required this.companyId,
      this.title,
      this.salary,
      this.deadline,
      this.workingForm,
      this.numberOfRecruits,
      this.gender,
      this.experience,
      this.position,
      this.address,
      this.descriptionWorking,
      this.request,
      this.benefit,
      this.createdAt,
      this.updatedAt,
      this.id,
      this.statusShow,
      this.isActive});

  factory Recruitment.fromJson(Map<String, dynamic> json) => Recruitment(
        companyId: json["company_id"],
        title: json["title"],
        salary: json["salary"],
        deadline: DateTime.parse(json["deadline"]),
        workingForm: json["workingForm"],
        numberOfRecruits: json["numberOfRecruits"],
        gender: json["gender"],
        experience: json["experience"],
        position: json["position"],
        address: json["address"],
        descriptionWorking: json["descriptionWorking"],
        request: json["request"],
        benefit: json["benefit"],
        createdAt: DateTime.parse(json["createdAt"]),
        updatedAt: DateTime.parse(json["updatedAt"]),
        id: json["id"],
        statusShow: json["statusShow"] ?? false,
        isActive: json["is_active"] ?? true,
      );

  Map<String, dynamic> toJson() => {
        "company_id": companyId,
        "title": title,
        "salary": salary,
        "deadline": deadline!.toIso8601String(),
        "workingForm": workingForm,
        "numberOfRecruits": numberOfRecruits.toString(),
        "gender": gender,
        "experience": experience,
        "position": position,
        "address": address,
        "descriptionWorking": descriptionWorking,
        "request": request,
        "benefit": benefit,
        "statusShow": statusShow.toString(),
        "is_active": isActive.toString(),
      };
}
