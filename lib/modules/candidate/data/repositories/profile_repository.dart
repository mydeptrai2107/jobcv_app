import 'dart:convert';

import 'package:app/configs/uri.dart';
import 'package:http/http.dart' as http;

class ProfileRepository {
  final String urlCreateCV = '${uriApiApp}api/user/';
  final String urlDeleteProfile = '${uriApiApp}api/user/profile/';
  final String urlUpdateProfile = '${uriApiApp}api/user/profile/';
  final String urlPdfProfile = '${uriApiApp}static/cv/';

  Future<Map<String, dynamic>> createProfile(String name, String idUser) async {
    var url = Uri.parse('$urlCreateCV$idUser/profile');
    final response = await http.post(url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'name': name}));

    if (response.statusCode == 201) {
      return jsonDecode(response.body);
    } else {
      throw response.body;
    }
  }

  Future<List<dynamic>> getListProfile(String idUser) async {
    var url = Uri.parse('$urlCreateCV$idUser/profiles');
    final response = await http.get(
      url,
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw response.body;
    }
  }

  Future deleteProfileById(String id) async {
    var url = Uri.parse('$urlDeleteProfile$id');
    final response = await http.delete(url);
    if (response.statusCode != 200) {
      throw response.body;
    }
  }

  Future<void> updateUserProfile(String id, String name, String pathCV) async {
    try {
      final url = Uri.parse('$urlUpdateProfile$id');

      final request = http.MultipartRequest('PUT', url);

      request.fields['name'] = name;

      final pdfFileField = await http.MultipartFile.fromPath('pdf', pathCV);
      request.files.add(pdfFileField);

      final response = await request.send();

      if (response.statusCode != 200) {
        throw response.statusCode;
      }
    } catch (error) {
      rethrow;
    }
  }
}
