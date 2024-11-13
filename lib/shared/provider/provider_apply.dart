import 'dart:developer';

import 'package:app/modules/candidate/data/models/apply_model.dart';
import 'package:app/modules/candidate/data/models/profile_model.dart';
import 'package:app/modules/candidate/data/models/user_model.dart';
import 'package:app/modules/candidate/data/repositories/apply_repositories.dart';
import 'package:app/modules/candidate/domain/providers/provider_auth.dart';
import 'package:app/shared/models/recruitment_like_model.dart';
import 'package:app/shared/models/recruitment_model.dart';
import 'package:app/shared/provider/provider_company.dart';
import 'package:app/shared/provider/provider_recruitment.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:string_similarity/string_similarity.dart';

class ProviderApply extends ChangeNotifier {
  final ApplyRepository _applyRepository = ApplyRepository();
  //ProviderAuth providerAuth = ProviderAuth();
  ProviderRecruitment providerRecruitment = ProviderRecruitment();
  ProviderCompany providerCompany = ProviderCompany();

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  Future<Apply> createApply(String idUser, String idProfile, String idRecruit, String nameRecruit,
      String idCompany, String comment) async {
    try {
      _isLoading = true;
      notifyListeners();
      Map<String, dynamic> responseBody = await _applyRepository.createApply(
          idUser, idProfile, idRecruit,nameRecruit, idCompany, comment);
      Apply apply = Apply.fromJson(responseBody);
      _isLoading = false;
      notifyListeners();
      return apply;
    } catch (e) {
      _isLoading = false;
      notifyListeners();
      rethrow;
    }
  }

  Future<List<Apply>> getListApply(String idUser) async {
    try {
      List<dynamic> responseBody =
          await _applyRepository.getListApplyByIdUser(idUser);
      Iterable it = responseBody;
      List<Apply> list = it.map((e) => Apply.fromJson(e)).toList();
      return list;
    } catch (e) {
      rethrow;
    }
  }

  Future<List<Recruitment>> suggestRecuitment(String idUser) async {
    try {
      List<Recruitment> list = [];
      List<Apply> applys = await getListApply(idUser);
      Apply apply = applys[applys.length - 1];
      RecruitmentLike recruitment = await Modular.get<ProviderRecruitment>()
          .getRecruitById(apply.recruitmentId);
      List<RecruitmentLike> recruitments =
          await Modular.get<ProviderRecruitment>().getListRecruitment();
      for (int i = 0; i < recruitments.length; i++) {
        if (recruitment.recruitment.title
                    .similarityTo(recruitments[i].recruitment.title) *
                100 >
            25) {
          list.add(recruitments[i].recruitment);
        }
      }
      return list;
    } catch (e) {
      rethrow;
    }
  }

  Future<List<Apply>> getListApplyByRecruitment(String id) async {
    try {
      final res = await _applyRepository.getApplyByRecruitment(id);
      notifyListeners();
      return res;
    } catch (e) {
      log(e.toString());
      return [];
    }
  }

  Future<List<Apply>> getListApplyByComapny(String id) async {
    try {
      List<dynamic> responseBody =
          await _applyRepository.getListApplyByIdComapny(id);
      Iterable it = responseBody;
      List<Apply> list = it.map((e) => Apply.fromJson(e)).toList();
      notifyListeners();
      return list;
    } catch (e) {
      log(e.toString());
      return [];
    }
  }

  Future<bool> checkRecruitmentApplied(String rid, String idUser) async {
    try {
      List<Apply> listApply = await getListApply(idUser);
      List<String> listIdRecuitmentApplied = [];
      listApply.map((e) {
        listIdRecuitmentApplied.add(e.recruitmentId);
      }).toList();
      bool check = listIdRecuitmentApplied.contains(rid);
      return check;
    } catch (e) {
      rethrow;
    }
  }

  Future<int> countDayApplied(String rid, String idUser) async {
    try {
      List<Apply> listApply = await getListApply(idUser);

      for (int i = 0; i < listApply.length; i++) {
        if (listApply[i].recruitmentId == rid) {
          return DateTime.now().difference(listApply[i].createdAt).inDays;
        }
      }
      return -1;
    } catch (e) {
      _isLoading = false;
      notifyListeners();
      rethrow;
    }
  }

  Future<int> getCountApply() async {
    try {
      UserModel user = Modular.get<ProviderAuth>().user;

      List<Apply> list = await getListApply(user.userId);
      notifyListeners();
      return list.length;
    } catch (e) {
      rethrow;
    }
  }

  Future<List<Apply>> getListApply7Day(String idUser) async {
    try {
      List<Apply> listApply = await getListApply(idUser);
      List<Apply> list = [];
      listApply.map((e) {
        if (DateTime.now().difference(e.createdAt).inDays >= 0 &&
            DateTime.now().difference(e.createdAt).inDays <= 7) {
          list.add(e);
        }
      }).toList();
      return list;
    } catch (e) {
      rethrow;
    }
  }

  Future<List<Apply>> getListApply30Day(String idUser) async {
    try {
      _isLoading = true;
      notifyListeners();
      List<Apply> listApply = await getListApply(idUser);
      List<Apply> list = [];
      listApply.map((e) {
        if (DateTime.now().difference(e.createdAt).inDays >= 7 &&
            DateTime.now().difference(e.createdAt).inDays <= 30) {
          list.add(e);
        }
      }).toList();
      _isLoading = false;
      notifyListeners();
      return list;
    } catch (e) {
      _isLoading = false;
      notifyListeners();
      rethrow;
    }
  }

  Future<Profile> getProfileApplied(String idApply) async {
    try {
      _isLoading = true;
      Map<String, dynamic> responseBody =
          await _applyRepository.getApplyByID(idApply);
      Profile profile = Profile.fromJson(responseBody);
      _isLoading = false;
      notifyListeners();
      return profile;
    } catch (e) {
      _isLoading = true;
      notifyListeners();
      rethrow;
    }
  }

  Future<Profile> getProfileByUserId(String id) async {
    try {
      final res = await _applyRepository.getApplyByUserId(id);
      return res;
    } catch (e) {
      _isLoading = true;
      notifyListeners();
      rethrow;
    }
  }

  Future updateCv(String id, String status) async {
    try {
      await _applyRepository.updateApply(id, status);
      notifyListeners();
    } catch (e) {
      log(e.toString());
    }
  }
}
