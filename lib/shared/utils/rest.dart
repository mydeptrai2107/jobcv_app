import 'dart:convert';

import 'package:http/http.dart' as http;

class Rest {
  static String token =
      'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJwYXlsb2FkIjp7IkNvbXBhbnlJZCI6IjY0NzRkMWUyMmJhMWM1MWNlZTBjZThmOCIsImFjY291bnRJZCI6IjY0NzRkMWUyMmJhMWM1MWNlZTBjZThmYSIsImVtYWlsIjoiZnB0QGdtYWlsLmNvbSIsIm5hbWUiOiJGUFQgU29mdHdhcmUiLCJjb250YWN0IjoiZnB0c29mdHdhcmVAZ21haWwuY29tIiwiaW5mbyI6Imh0dHBzOi8vd3d3LmZwdC1zb2Z0d2FyZS5jb20ifSwiaWF0IjoxNjg2NTQyMTY3LCJleHAiOjE2ODY1NDI3Njd9.jqnRz_Xx4AAsSEsaYEve673nDWyUCXmScpY-ZsduG2M';
  static Map<String, String> _setHeaders() {
    return {'Authorization': 'Bearer $token'};
  }

  static Future<dynamic> get(String url,
      {Map<String, String>? headers,
      dynamic body,
      Map<String, dynamic>? params}) async {
    final uri = Uri.parse(url).replace(queryParameters: params);

    final response = await http.get(
      uri,
      headers: headers,
    );
    final res = jsonDecode(response.body);
    return res;
  }

  static Future<dynamic> post(String url,
      {Map<String, String>? headers,
      dynamic body,
      Map<String, dynamic>? params}) async {
    final uri = Uri.parse(url).replace(queryParameters: params);

    final response =
        await http.post(uri, headers: headers ?? _setHeaders(), body: body);
    final res = jsonDecode(response.body);
    return res;
  }

  static Future<dynamic> update(String url,
      {Map<String, String>? headers,
      dynamic body,
      Map<String, dynamic>? params}) async {
    final uri = Uri.parse(url).replace(queryParameters: params);

    final response =
        await http.put(uri, headers: headers ?? _setHeaders(), body: body);
    final res = jsonDecode(response.body);
    return res;
  }
  static Future<dynamic> delete(String url,
      {Map<String, String>? headers,
      dynamic body,
      Map<String, dynamic>? params}) async {
    final uri = Uri.parse(url).replace(queryParameters: params);

    final response =
        await http.delete(uri, headers: headers ?? _setHeaders(), body: body);
    final res = jsonDecode(response.body);
    return res;
  }
}
