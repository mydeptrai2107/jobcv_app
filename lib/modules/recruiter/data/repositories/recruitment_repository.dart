import 'package:app/configs/uri.dart';
import 'package:app/shared/models/recruitment_model.dart';
import 'package:app/shared/utils/rest.dart';

class RecruitmentService {
  static Future<Recruitment> createRecruitment(Recruitment recruitment) async {
    final res = await Rest.post('${uriApiApp}api/recruitment/',
        body: recruitment.toJson());
    final item = Recruitment.fromJson(res);
    return item;
  }

  static Future<List<Recruitment>> getRecruitments(String id) async {
    final res = await Rest.get('${uriApiApp}api/recruitment/comid/$id');
    final list = (res as List)
        .map((e) => Recruitment.fromJson(e['recruitment']))
        .toList();
    return list;
  }

  static Future<List<Recruitment>> getLisCv(String id) async {
    final res = await Rest.get('${uriApiApp}api/recruitment/$id');
    final list = (res as List).map((e) => Recruitment.fromJson(e)).toList();
    return list;
  }

  static Future<Recruitment> updateRecruitment(Recruitment recruitment) async {
    final res = await Rest.update(
        '${uriApiApp}api/recruitment/${recruitment.id}',
        body: recruitment.toJson());
    final item = Recruitment.fromJson(res);
    return item;
  }

  static Future deleteRecruitment(String id) async {
    await Rest.delete(
      '${uriApiApp}api/recruitment/$id',
    );
  }
}
