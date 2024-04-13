import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:eshop/shared/environments/environment.dart';

import '../../shared/interceptors/headers_interceptors.dart';
import 'models/contact_models.dart';

class CheckoutRepository {
  Environment environment = Environment.instance;

  Future<ContactInfosModel> getContactInfos() async {
    var dio = Dio();
    dio.interceptors.add(DioInterceptor());

    var response = await dio.request(
      environment.getBaseUrl + environment.user_contact_infos_sub_url,
      options: Options(
        method: 'GET',
      ),
    );

    if (response.statusCode == 200) {
      print(json.encode(response.data));
      return ContactInfosModel.fromJson(response.data);
    } else {
      print(response.statusMessage);
      throw Exception('Failed to load contact infos');
    }
  }
}
