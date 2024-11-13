import 'dart:convert';

import 'package:app/configs/uri.dart';
import 'package:app/modules/candidate/data/models/apply_model.dart';
import 'package:app/modules/candidate/data/models/profile_model.dart';
import 'package:app/shared/utils/rest.dart';
import 'package:http/http.dart' as http;

class ApplyRepository {
  final String urlCreateApply = '${uriApiApp}api/apply';
  final String urlGetListApplyBuIdUser = '${uriApiApp}api/apply/uid/';
  final String urlGetListApplyByIdCompany = '${uriApiApp}api/apply/cid/';


  Future<Map<String, dynamic>> createApply(
      String idUser, String idProfile, String idRecruit, String nameRecruit, String idCompany, String comment) async {
    var url = Uri.parse(urlCreateApply);
    final response = await http.post(url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'user_id': idUser,
          'user_profile_id': idProfile,
          'recruitment_id': idRecruit,
          'recruitment_name': nameRecruit,
          'company_id': idCompany,
          'comment': comment
        }));
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw response.body;
    }
  }

  Future<List<dynamic>> getListApplyByIdUser(String id) async {
    var url = Uri.parse(urlGetListApplyBuIdUser + id);
    final response = await http.get(url);
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw response.body;
    }
  }

  Future<List<dynamic>> getListApplyByIdComapny(String id) async {
    var url = Uri.parse(urlGetListApplyByIdCompany + id);
    final response = await http.get(url);
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw response.body;
    }
  }

  Future<Map<String, dynamic>> getApplyByID(String id) async {
    var url = Uri.parse('$urlCreateApply/$id');
    final response = await http.get(url);
    if (response.statusCode == 200) {
      return jsonDecode(response.body)['userProfile'];
    } else {
      throw response.body;
    }
  }

  Future<Profile> getApplyByUserId(String id) async {
    final res = await Rest.get('${uriApiApp}api/user/profile/$id');
    return Profile.fromJson(res);
  }

  Future<List<Apply>> getApplyByRecruitment(String id) async {
    final res = await Rest.get('${uriApiApp}api/apply/rid/$id');
    final list = (res as List).map((e) => Apply.fromJson(e)).toList();
    return list;
  }

  Future updateApply(String id, String status) async {
    await Rest.update('${uriApiApp}api/apply/update',
        body: {"applyId": id, "newStatus": status});
  }
}
