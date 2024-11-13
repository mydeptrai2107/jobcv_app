import 'package:app/modules/candidate/data/models/province.dart';
import 'package:app/modules/candidate/data/repositories/repository_map_vn.dart';

class GetProvince {
  final ReporitoryMap reporitpryMap;
  GetProvince({required this.reporitpryMap});

  Future<List<Province>> get() async {
    return await reporitpryMap.getProvince();
  }
}
