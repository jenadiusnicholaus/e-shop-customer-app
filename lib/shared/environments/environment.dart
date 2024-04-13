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

  // 'http://localhost:8000/api/authentication/v1/google-signin/',
  String google_signin_sub_url = "authentication/$API_VERSION/google-signin/";

  // http://localhost:8000/api/authentication/v1/user-contact-infos/

  String user_contact_infos_sub_url =
      "authentication/$API_VERSION/user-contact-infos/";

  // http://localhost:8000/api/category/v1/mobile-category-list/
  String category_list_sub_url = "category/$API_VERSION/mobile-category-list/";

  // http://localhost:8000/api/authentication/v1/token/refresh/
  String token_refresh_sub_url = "authentication/$API_VERSION/token/refresh/";

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
