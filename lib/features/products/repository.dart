import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:eshop/features/products/models.dart';

class ProductRepository {
  Future<ProductModel> fetchProducts() async {
    var headers = {
      'Content-Type': 'application/json',
      'Authorization':
          'Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ0b2tlbl90eXBlIjoiYWNjZXNzIiwiZXhwIjoxNzA5NjUyNDM4LCJpYXQiOjE3MDk1NjYwMzgsImp0aSI6IjdmMzQwMGE2MTI0NDQyMDliZDI3NWFjODcwMDA2YjhlIiwidXNlcl9pZCI6MiwiaXNfc3RhZmYiOnRydWUsInR5cGUiOiJDTElFTlQifQ.J_2GD_2jSPfdRkd47C-Py0mBpwlYfz28-cABG_EaN9E',
      'Cookie': 'sessionid=e1cpz4p1cnb8puq6xuxyytjydmfofyrv'
    };
    var data = json.encode({
      "id": 1,
      "category": 1,
      "name": "Coffe844",
      "description": "coffee",
      "status": "1"
    });
    var dio = Dio();
    var response = await dio.request(
      'http://192.168.1.181:8000/api/products/v1/product_vset/',
      options: Options(
        method: 'GET',
        headers: headers,
      ),
      data: data,
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
