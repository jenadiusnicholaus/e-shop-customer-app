import 'dart:convert';
import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:eshop/shared/environments/environment.dart';
import 'package:eshop/shared/utils/secure_local_storage.dart';
import 'package:get/get.dart' as Gt;

class DioInterceptor extends Interceptor {
  Environment environment = Environment.instance;
  Dio? dio;

  DioInterceptor() {
    dio = Dio(BaseOptions(baseUrl: environment.getBaseUrl));
  }

  @override
  void onRequest(
      RequestOptions options, RequestInterceptorHandler handler) async {
    String token = await SecureLocalStorage.readValue("access_token") ?? '';
    options.headers.addAll({
      "Content-Type": "application/json",
      // "Authorization": "Bearer $token",
    });
    // get token from the storage
    if (token.isNotEmpty) {
      options.headers.addAll({
        "Authorization": "Bearer $token",
      });
    }
    return super.onRequest(options, handler);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    return super.onResponse(response, handler);
  }

  void onError(DioException err, ErrorInterceptorHandler handler) async {
    // Check if the user is unauthorized.
    if (err.response?.statusCode == 401) {
      log("Token expired");
      log(err.message.toString());
      log(err.response!.statusCode.toString());
      // Refresh the user's authentication token.
      Response res = await refreshToken();
      await SecureLocalStorage.writeValue("access_token", res.data['access']);

      // Retry the request.
      try {
        handler.resolve(await _retry(err.requestOptions));
      } on DioException catch (e) {
        log(e.message!);
        // If the request fails again, pass the error to the next interceptor in the chain.
        handler.next(e);
      }
      // Return to prevent the next interceptor in the chain from being executed.
      return;
    }
    // Pass the error to the next interceptor in the chain.
    handler.next(err);
  }

  Future<Response<dynamic>> refreshToken() async {
    // Send a request to the server to refresh the user's authentication token.
    String rtoken = await SecureLocalStorage.readValue("refresh_token") ?? '';

    var data = json.encode({
      "refresh": rtoken, // the refresh token is used to get a new access token
    });
    var dio = Dio();
    var refreshUrl = environment.getBaseUrl + environment.token_refresh_sub_url;

    var response = await dio.request(
      refreshUrl,
      options: Options(
        method: 'POST',
      ),
      data: data,
    );

    if (response.statusCode == 200) {
      return response;
    } else {
      Gt.Get.toNamed('/login');
      throw Exception('Failed to refresh token');
    }
  }

  Future<Response<dynamic>> _retry(RequestOptions requestOptions) async {
    // Create a new `RequestOptions` object with the same method, path, data, and query parameters as the original request.
    String token = await SecureLocalStorage.readValue("access_token") ?? '';

    final options = Options(
      method: requestOptions.method,
      headers: {
        "Authorization": "Bearer ${token}",
      },
    );

    // Retry the request with the new `RequestOptions` object.
    return dio!.request<dynamic>(requestOptions.path,
        data: requestOptions.data,
        queryParameters: requestOptions.queryParameters,
        options: options);
  }
}
