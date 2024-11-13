class Recruiter {
  String? contact;
  String? info;
  String? name;
  String email;
  String id;

  Recruiter({required this.email, this.contact, this.info, this.name,required this.id});

  factory Recruiter.fromJson(Map<String, dynamic> json) {
    return Recruiter(
      contact: json['contact'] ?? '',
      info: json['info'] ?? '',
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      id: json['CompanyId'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['contact'] = contact;
    data['info'] = info;
    data['email'] = email;
    data['name'] = name;
    return data;
  }
}
