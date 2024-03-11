import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:eshop/features/auth/login/models.dart';

class AuthRepository {
  AuthRepository();

  Future<LoginModel> login(String email, String password) async {
    var headers = {
      'Content-Type': 'application/json',
      'Authorization':
          'Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ0b2tlbl90eXBlIjoiYWNjZXNzIiwiZXhwIjoxNzEwMDU4ODUxLCJpYXQiOjE3MDk5NzI0NTEsImp0aSI6IjkyYzkwY2U2NjA2ZTRkNDg5Y2E4M2M3Y2MzNzRmYWFjIiwidXNlcl9pZCI6MSwiaXNfc3RhZmYiOnRydWUsInR5cGUiOiJDTElFTlQifQ.-ZZk2hNMHAGRTDaYK0EzANq-ukZih8TQvAHjflSR9TY'
    };
    var data = json.encode({"username": "admin", "password": "1234"});
    var dio = Dio();
    var response = await dio.request(
      'http://localhost:8000/api/authentication/v1/login/',
      options: Options(
        method: 'POST',
        headers: headers,
      ),
      data: data,
    );

    if (response.statusCode == 200) {
      print(json.encode(response.data));
      return LoginModel.fromJson(response.data);
    } else {
      print(response.statusMessage);
      throw Exception('Failed to load album');
    }
  }
}
