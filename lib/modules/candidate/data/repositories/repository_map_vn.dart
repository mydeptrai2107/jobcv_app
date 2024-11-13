import 'dart:convert';

import 'package:app/modules/candidate/data/models/province.dart';
import 'package:flutter/services.dart';

class ReporitoryMap {
  Future getProvince() async {
    String uri = 'assets/data/city.json';
    try {
      final response = await rootBundle.loadString(uri);

      final data = jsonDecode(response);
      Iterable it = data;
      List<Province> list = it.map((e) => Province.fromJson(e)).toList();
      return list;
    } catch (e) {
      return e;
    }
  }
}
