import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SecureLocalStorage {
// Create storage
  static FlutterSecureStorage storage = const FlutterSecureStorage();

  static readValue(String key) async {
    String? value = await storage.read(key: key);
    return value;
  }

  static readAll() async {
    Map<String, String> allValues = await storage.readAll();
    return allValues;
  }

  static deleteValue(String key) async {
    await storage.delete(key: key);
  }

  static deleteAll() async {
    await storage.deleteAll();
  }

  static writeValue(String key, String value) async {
    await storage.write(key: key, value: value);
  }
}


