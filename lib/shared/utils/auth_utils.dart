import 'secure_local_storage.dart';

class AuthUtils {
  static Future<String> getAuthToken() async {
    return await SecureLocalStorage.readValue("access_token") ?? '';
  }

  isAuthorized() async {
    String? token = await getAuthToken();
    return token != '' ? true : false;
  }
}
