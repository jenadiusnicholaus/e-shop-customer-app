import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:eshop/features/products/models.dart';

class ProductRepository {
  Future<ProductModel> fetchProducts([String pageNo = '1']) async {
    var headers = {
      'Content-Type': 'application/json',
      'Authorization':
          'Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ0b2tlbl90eXBlIjoiYWNjZXNzIiwiZXhwIjoxNzA5NjUyNDM4LCJpYXQiOjE3MDk1NjYwMzgsImp0aSI6IjdmMzQwMGE2MTI0NDQyMDliZDI3NWFjODcwMDA2YjhlIiwidXNlcl9pZCI6MiwiaXNfc3RhZmYiOnRydWUsInR5cGUiOiJDTElFTlQifQ.J_2GD_2jSPfdRkd47C-Py0mBpwlYfz28-cABG_EaN9E'
    };

    var dio = Dio();
    var response = await dio.request(
      'http://192.168.1.181:8000//api/products/v1/all-products/?page=$pageNo',
      options: Options(
        method: 'GET',
        headers: headers,
      ),
    );

    if (response.statusCode == 200) {
      print(json.encode(response.data));
      return ProductModel.fromJson(response.data);
    } else {
      print(response.statusMessage);
      throw Exception('Failed to load album');
    }
  }
}
