import 'dart:developer';

import 'package:app/modules/candidate/data/models/company_model.dart';
import 'package:app/modules/recruiter/data/repositories/recruiter_repository.dart';
import 'package:app/shared/provider/provider_company.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';

class RecruiterProvider extends ChangeNotifier {
  Company get recruiter => _recruiter;
  Company _recruiter = Company(
      name: '',
      contact: '',
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
      id: '');

  Future<Company?> findMe() async {
    try {
      final res = await RecruiterRepository.findMe();
      final company = await ProviderCompany().getCompanyById(res!.id);
      _recruiter = company;
      notifyListeners();
      return company;
    } catch (e) {
      log(e.toString());

      return null;
    }
  }

  Future updateMe(Company company) async {
    try {
      final success = await RecruiterRepository.updateMe(company);
      if (success) {
        final res = await ProviderCompany().getCompanyById(company.id);
        _recruiter = res;
        notifyListeners();
        Modular.to.pop();
        ScaffoldMessenger.of(
                Modular.routerDelegate.navigatorKey.currentContext!)
            .showSnackBar(
                const SnackBar(content: Text('Cập nhật thành công !')));
        return company;
      }
    } catch (e) {
      log(e.toString());
      return null;
    }
  }
}
