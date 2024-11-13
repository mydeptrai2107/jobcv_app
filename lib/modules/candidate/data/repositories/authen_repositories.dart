import 'dart:convert';

import 'package:app/configs/uri.dart';
import 'package:http/http.dart' as http;
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthenRepositoris {
  final String uriLogin = "${uriApiApp}api/auth/login";
  final String uriRefreshToken = '${uriApiApp}api/auth/refresh-token';
  final String uriRegister = '${uriApiApp}api/auth/register';
  final String uriGetUser = '${uriApiApp}api/auth/';
  final String uriChangePw = '${uriApiApp}api/auth/change-pass';

  Future<bool> register(String email, String password, String confirmPW,
      String firstName, String lastName) async {
    var url = Uri.parse(uriRegister);
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var response = await http.post(url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'account_type': prefs.getString('account_type'),
          'email': email,
          'password': password,
          'confirm_password': confirmPW,
          'first_name': firstName,
          'last_name': lastName
        }));
    if (response.statusCode == 200) {
      return true;
    } else {
      throw response.body;
    }
  }

  Future<Map<String, dynamic>> login(String email, String password) async {
    var url = Uri.parse(uriLogin);
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var response = await http.post(url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'account_type': prefs.getString('account_type'),
          'email': email,
          'password': password
        }));

    if (response.statusCode == 200) {
      final responseBody = jsonDecode(response.body);
      return responseBody;
    } else {
      throw response.body;
    }
  }

  Future<void> checkTokenExpiration() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    String? accessToken = prefs.getString('accessToken');
    if (accessToken != null) {
      Map<String, dynamic> decodedToken = JwtDecoder.decode(accessToken);
      DateTime expirationDate =
          DateTime.fromMillisecondsSinceEpoch(decodedToken['exp'] * 1000);
      if (expirationDate.isBefore(DateTime.now())) {
        await refreshToken();
      }
    }
  }

  Future<void> refreshToken() async {
    var url = Uri.parse(uriRefreshToken);
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var response = await http.post(url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'account_type': prefs.getString('account_type'),
          'refreshToken': prefs.getString('refreshToken'),
        }));
    if (response.statusCode == 200) {
      var jsonResponse = json.decode(response.body);
      await prefs.setString('accessToken', jsonResponse['accessToken']);
      //await prefs.setString('refreshToken', jsonResponse['refreshToken']);
    }
  }

  Future<Map<String, dynamic>> getUser(String token) async {
    var url = Uri.parse(uriGetUser);
    Map<String, String> header = {
      'Content-Type': 'application/json; charset=UTF-8',
      'Authorization': 'Bearer $token'
    };
    final response = await http.get(url, headers: header);

    if (response.statusCode == 200) {
      final responbody = jsonDecode(response.body);
      return responbody;
    } else {
      throw response.body;
    }
  }

  Future<Map<String, dynamic>> changePassWord(String email, String oldPw,
      String newPw, String confirmPw, String accountType) async {
    var url = Uri.parse(uriChangePw);
    var response = await http.post(url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'account_type': accountType,
          'email': email,
          'oldPassword': oldPw,
          'newPassword': newPw,
          'confirmPassword': confirmPw
        }));

    if (response.statusCode == 200) {
      final responseBody = jsonDecode(response.body);
      return responseBody;
    } else {
      throw response.body;
    }
  }
}
