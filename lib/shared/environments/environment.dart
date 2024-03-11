// ignore_for_file: constant_identifier_names, non_constant_identifier_names

enum EnvironmentType { prod, staging, dev }

class Environment {
  static final Environment _instance = Environment._init();
  static Environment get instance => _instance;
  Environment._init();

  static String API_VERSION = "v1";

  // https://travel-monkey-app-backend-staging.azurewebsites.net/api/user-auth/v1/user-registration/

  static const String STAGING_BASE_URL = "";

  static const String PROD_BASE_URL = "";

  static const String DEV_BASE_URL = "http://192.168.1.181:8000/api/";
  static const String IMAGE_URL = "http://192.168.1.181:8000/";

  String tenant_registration_sub_url =
      "user-auth/$API_VERSION/user-registration/";
  String tenant_validate_account_sub_url =
      "user-auth/$API_VERSION/activate-account/";
  String tenant_login_sub_url = "user-auth/$API_VERSION/token/login/";

  String all_products_sub_url = "products/$API_VERSION/all-products/";

  String product_details_sub_url = "products/$API_VERSION/product-details/";

  static EnvironmentType environmentType = EnvironmentType.dev;

  String get getBaseUrl {
    switch (environmentType) {
      case EnvironmentType.staging:
        return STAGING_BASE_URL;
      case EnvironmentType.prod:
        return PROD_BASE_URL;
      case EnvironmentType.dev:
        return DEV_BASE_URL;
    }
  }
}
