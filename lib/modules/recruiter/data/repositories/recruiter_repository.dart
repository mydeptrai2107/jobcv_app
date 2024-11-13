import 'dart:developer';

import 'package:app/configs/uri.dart';
import 'package:app/modules/candidate/data/models/company_model.dart';
import 'package:app/modules/candidate/data/repositories/authen_repositories.dart';
import 'package:app/modules/recruiter/data/models/recruiter.dart';
import 'package:app/shared/utils/rest.dart';
import 'package:shared_preferences/shared_preferences.dart';

class RecruiterRepository {
  static Future<Recruiter?> findMe() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String accessToken = prefs.getString('accessToken')!;
      final res = await Rest.get('${uriApiApp}api/auth', headers: {
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer $accessToken'
      });
      final item = Recruiter.fromJson(res);
      if (item.id.isEmpty) {
        await AuthenRepositoris().checkTokenExpiration();
        await findMe();
      }
      return item;
    } catch (e) {
      await AuthenRepositoris().checkTokenExpiration();
      await findMe();
      return null;
    }
  }

  static Future<bool> updateMe(Company recruiter) async {
    try {
      await Rest.update('${uriApiApp}api/company/${recruiter.id}',
          body: recruiter.toJson());
      return true;
    } catch (e) {
      log(e.toString());
      return false;
    }
  }
}
