import 'dart:convert';
import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:eshop/features/auth/login/models.dart';
import 'package:eshop/shared/environments/environment.dart';

class AuthRepository {
  Environment environment = Environment.instance;
  AuthRepository();

  Future<LoginModel> login(String email, String password) async {
    var headers = {
      'Content-Type': 'application/json',
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

  Future<LoginModel> loginWithGoogle({String? idToken}) async {
    var headers = {'Content-Type': 'application/json'};
    var data = json.encode({"access_token": idToken});
    var dio = Dio();
    var response = await dio.request(
      environment.getBaseUrl + environment.google_signin_sub_url,
      options: Options(
        method: 'POST',
        headers: headers,
      ),
      data: data,
    );

    if (response.statusCode == 200) {
      log(json.encode(response.data));
      return LoginModel.fromJson(response.data);
    } else {
      log(response.statusMessage.toString());
      throw Exception('Failed to load album');
    }
  }
}
