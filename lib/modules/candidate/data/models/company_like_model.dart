// To parse this JSON data, do
//
//     final companyLike = companyLikeFromJson(jsonString);

import 'dart:convert';

import 'package:app/modules/candidate/data/models/company_model.dart';

CompanyLike companyLikeFromJson(String str) => CompanyLike.fromJson(json.decode(str));

String companyLikeToJson(CompanyLike data) => json.encode(data.toJson());

class CompanyLike {
    Company company;
    int totalSaved;

    CompanyLike({
        required this.company,
        required this.totalSaved,
    });

    factory CompanyLike.fromJson(Map<String, dynamic> json) => CompanyLike(
        company: Company.fromJson(json["company"]),
        totalSaved: json["totalSaved"],
    );

    Map<String, dynamic> toJson() => {
        "company": company.toJson(),
        "totalSaved": totalSaved,
    };
}