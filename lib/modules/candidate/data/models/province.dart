// To parse this JSON data, do
//
//     final province = provinceFromJson(jsonString);

import 'dart:convert';

Province provinceFromJson(String str) => Province.fromJson(json.decode(str));

String provinceToJson(Province data) => json.encode(data.toJson());

class Province {
  String cityCode;
  String name;
  String nameWithType;
  String countryId;
  String areaId;

  Province({
    required this.cityCode,
    required this.name,
    required this.nameWithType,
    required this.countryId,
    required this.areaId,
  });

  factory Province.fromJson(Map<String, dynamic> json) => Province(
        cityCode: json["city_code"],
        name: json["name"],
        nameWithType: json["name_with_type"],
        countryId: json["country_id"],
        areaId: json["area_id"],
      );

  Map<String, dynamic> toJson() => {
        "city_code": cityCode,
        "name": name,
        "name_with_type": nameWithType,
        "country_id": countryId,
        "area_id": areaId,
      };
}
