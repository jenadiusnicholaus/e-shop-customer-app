import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:eshop/shared/environments/environment.dart';

import 'models/prodict_details_model.dart';

class ProductRepository {
  // produdct details
  Environment environment = Environment.instance;

  Future<ProductDetailsModel> getProductDetails(String id) async {
    var headers = {'Cookie': 'sessionid=e1cpz4p1cnb8puq6xuxyytjydmfofyrv'};
    var dio = Dio();
    var response = await dio.request(
      '${environment.getBaseUrl}${environment.product_details_sub_url}?product_id=$id',
      options: Options(
        method: 'GET',
        headers: headers,
      ),
    );

    if (response.statusCode == 200) {
      print(json.encode(response.data));
      return ProductDetailsModel.fromJson(response.data);
    } else {
      print(response.statusMessage);
      throw Exception('Failed to load album');
    }
  }
}
