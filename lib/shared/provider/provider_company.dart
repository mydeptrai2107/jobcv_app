import 'package:app/modules/candidate/data/models/action_company_model.dart';
import 'package:app/modules/candidate/data/models/company_like_model.dart';
import 'package:app/modules/candidate/data/models/company_model.dart';
import 'package:app/modules/candidate/data/repositories/company_repositories.dart';
import 'package:flutter/material.dart';

class ProviderCompany extends ChangeNotifier {
  CompanyRepository companyRepository = CompanyRepository();

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  bool _isLoadingGetList = false;
  bool get isLoadingGetList => _isLoadingGetList;

  bool _isLoadingSearch = false;
  bool get isLoadingSearch => _isLoadingSearch;
  late Company _company;
  Company get company => _company;
  Future<List<Company>> getListCompany() async {
    try {
      _isLoadingGetList = true;
      List<dynamic> responseBody = await companyRepository.getListCompany();
      Iterable it = responseBody;
      List<CompanyLike> listCompanyLike =
          it.map((e) => CompanyLike.fromJson(e)).toList();

      List<Company> listCompany = [];
      listCompanyLike.map((e) {
        listCompany.add(e.company);
      }).toList();
      _isLoadingGetList = false;
      notifyListeners();
      return listCompany;
    } catch (e) {
      _isLoadingGetList = false;
      notifyListeners();
      rethrow;
    }
  }

  Future<List<Company>> getListCompanyOutStanding() async {
    try {
      _isLoadingGetList = true;
      List<dynamic> responseBody = await companyRepository.getListCompany();
      Iterable it = responseBody;
      List<CompanyLike> listCompanyLike =
          it.map((e) => CompanyLike.fromJson(e)).toList();

      listCompanyLike.sort(
        (a, b) => b.totalSaved.compareTo(a.totalSaved),
      );

      List<Company> listCompany = [];
      for (int i = 0;
          listCompanyLike.length > 6 ? i < 6 : i < listCompanyLike.length;
          i++) {
        listCompany.add(listCompanyLike[i].company);
      }
      notifyListeners();
      return listCompany;
    } catch (e) {
      _isLoadingGetList = false;
      notifyListeners();
      rethrow;
    }
  }

  Future<List<CompanyLike>> getListCompanyLike() async {
    try {
      _isLoadingGetList = true;
      List<dynamic> responseBody = await companyRepository.getListCompany();
      Iterable it = responseBody;
      List<CompanyLike> listCompanyLike =
          it.map((e) => CompanyLike.fromJson(e)).toList();
      return listCompanyLike;
    } catch (e) {
      rethrow;
    }
  }

  Future<int> getCountFollow(String idCompany) async {
    try {
      int count = 0;
      List<CompanyLike> companyLikes = await getListCompanyLike();
      for (int i = 0; i < companyLikes.length; i++) {
        if (companyLikes[i].company.id == idCompany) {
          return companyLikes[i].totalSaved;
        }
      }
      return count;
    } catch (e) {
      rethrow;
    }
  }

  Future<List<Company>> getCompanyByName(String name) async {
    try {
      _isLoadingSearch = true;
      List<dynamic> responseBody =
          await companyRepository.getListCompanyByName(name);
      Iterable it = responseBody;
      List<Company> listCompany = it.map((e) => Company.fromJson(e)).toList();
      _isLoadingSearch = false;
      notifyListeners();
      return listCompany;
    } catch (e) {
      _isLoadingSearch = false;
      notifyListeners();
      rethrow;
    }
  }

  Future<Company> getCompanyById(String id) async {
    try {
      Map<String, dynamic> responseBody =
          await companyRepository.getCompanyById(id);
      _company = Company.fromJson(responseBody['company']);
    notifyListeners();
      return _company;
    } catch (e) {
      rethrow;
    }
  }

  Future<int> getQuantityCompany() async {
    try {
      List<Company> responseBody = await getListCompany();
      notifyListeners();
      return responseBody.length;
    } catch (e) {
      rethrow;
    }
  }

  Future<List<Company>> getListCompanyPaging(int number) async {
    try {
      _isLoadingGetList = true;
      List<Company> listCompany = await getListCompany();
      List<Company> listPaging = [];
      if (8 * number < listCompany.length) {
        listPaging = listCompany.sublist(8 * (number - 1), 8 * number);
      } else {
        listPaging = listCompany.sublist(8 * (number - 1));
      }
      _isLoadingGetList = false;
      notifyListeners();
      return listPaging;
    } catch (e) {
      _isLoadingGetList = false;
      notifyListeners();
      rethrow;
    }
  }

  Future<ActionCompanyModel> actionSave(
      String comid, String userId, bool save) async {
    try {
      _isLoading = true;
      Map<String, dynamic> responseBody =
          await companyRepository.actionSaveCompany(comid, userId, save);
      ActionCompanyModel action = ActionCompanyModel.fromJson(responseBody);
      _isLoading = false;
      notifyListeners();
      return action;
    } catch (e) {
      _isLoading = false;
      notifyListeners();
      rethrow;
    }
  }

  Future<List<String>> getListIdCompanySaved(String userId) async {
    try {
      _isLoading = true;
      List<dynamic> responseBody =
          await companyRepository.getListIdCompanySaved(userId);
      Iterable it = responseBody;
      List<String> list = it.map((e) => e.toString()).toList();
      _isLoading = false;
      notifyListeners();
      return list;
    } catch (e) {
      _isLoading = false;
      notifyListeners();
      rethrow;
    }
  }

  Future<int> getCountCompanySaved(String userId) async {
    try {
      _isLoading = true;
      List<String> list = await getListIdCompanySaved(userId);
      _isLoading = false;
      notifyListeners();
      return list.length;
    } catch (e) {
      _isLoading = false;
      notifyListeners();
      rethrow;
    }
  }

  Future<List<Company>> getListCompanySaved(String userId) async {
    try {
      _isLoading = true;
      notifyListeners();
      List<dynamic> responseBody =
          await companyRepository.getListCompanySaved(userId);
      Iterable it = responseBody;
      List<Company> list = it.map((e) => Company.fromJson(e)).toList();
      _isLoading = false;
      notifyListeners();
      return list;
    } catch (e) {
      _isLoading = false;
      notifyListeners();
      rethrow;
    }
  }
}
