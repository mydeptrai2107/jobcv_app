import 'dart:io';

import 'package:app/modules/candidate/data/repositories/authen_repositories.dart';
import 'package:app/modules/candidate/data/repositories/user_repositories.dart';
import 'package:app/modules/candidate/data/repositories/user_show_model.dart';
import 'package:flutter/material.dart';

class ProviderUser extends ChangeNotifier {
  UserRepositories userRepositories = UserRepositories();
  AuthenRepositoris authenRepositoris = AuthenRepositoris();

  bool _isLoadingUpdateUser = false;

  bool get isLoadingUpdateUser => _isLoadingUpdateUser;

  Future<void> updateUser(
      {required String firsName,
      required String lastName,
      required String? phone,
      required String? gender,
      File? avatar,
      required String id}) async {
    try {
      _isLoadingUpdateUser = true;
      await userRepositories.updateUser(
          firsName: firsName,
          lastName: lastName,
          phone: phone,
          gender: gender,
          avatar: avatar,
          id: id);
      authenRepositoris.refreshToken();
      _isLoadingUpdateUser = false;
      notifyListeners();
    } catch (e) {
      _isLoadingUpdateUser = false;
      notifyListeners();
      rethrow;
    }
  }

  Future<void> updateAvatar({File? avatar, required String id}) async {
    try {
      _isLoadingUpdateUser = true;
      await userRepositories.updateAvatar(avatar: avatar, id: id);
      authenRepositoris.refreshToken();
      _isLoadingUpdateUser = false;
      notifyListeners();
    } catch (e) {
      _isLoadingUpdateUser = false;
      notifyListeners();
      rethrow;
    }
  }

  Future<void> updateUserAttribute(
      {required String key, required String value, required String id}) async {
    try {
      _isLoadingUpdateUser = true;
      await userRepositories.updateUserAttribute(
          key: key, value: value, id: id);
      authenRepositoris.refreshToken();
      _isLoadingUpdateUser = false;
      notifyListeners();
    } catch (e) {
      _isLoadingUpdateUser = false;
      notifyListeners();
      rethrow;
    }
  }

  Future<UserShow> getUserById(String id) async {
    try {
      Map<String, dynamic> responseBody =
          await userRepositories.getUserById(id: id);
      UserShow user = UserShow.fromJson(responseBody);
      notifyListeners();
      return user;
    } catch (e) {
      rethrow;
    }
  }
}
