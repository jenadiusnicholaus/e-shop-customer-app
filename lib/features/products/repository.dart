import 'dart:developer';
import 'package:dio/dio.dart';
import 'package:eshop/shared/environments/environment.dart';
import 'models/prodict_details_model.dart';

class ProductRepository {
  // produdct details
  Environment environment = Environment.instance;
  Future<ProductDetailsModel> getProductDetails(String id) async {
    var dio = Dio();
    var response = await dio.request(
      '${environment.getBaseUrl}${environment.product_details_sub_url}?product_id=$id',
      options: Options(
        method: 'GET',
      ),
    );

    log(response.statusCode.toString());

    if (response.statusCode == 200) {
      return ProductDetailsModel.fromJson(response.data);
    } else {
      
      throw Exception('Failed to load album');
    }
  }
}
