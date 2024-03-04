import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:eshop/features/auth/login/models.dart';

class AuthRepository {
  AuthRepository();

  Future<LoginModel> login(String email, String password) async {
    var headers = {
      'Content-Type': 'application/json',
      'Authorization':
          'Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ0b2tlbl90eXBlIjoiYWNjZXNzIiwiZXhwIjoxNzA1MTU5ODQ1LCJpYXQiOjE3MDUxNTQ0NDUsImp0aSI6IjhkNWY4YTU0YjZmZjQ5ZTBiNWY4MTIwNzJlYzVlOGU4IiwidXNlcl9pZCI6MTQsImlzX3N0YWZmIjp0cnVlLCJyb2xlIjoiQ0xJRU5UIn0.NxWIRi1Lx4PXqrdlm_qnHXzKDjgO0grVoszlEk9KcUA',
      'Cookie': 'sessionid=e1cpz4p1cnb8puq6xuxyytjydmfofyrv'
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
