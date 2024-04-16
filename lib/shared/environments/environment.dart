// ignore_for_file: constant_identifier_names, non_constant_identifier_names

enum EnvironmentType { prod, staging, local_dev, remote_dev }

class Environment {
  static final Environment _instance = Environment._init();
  static Environment get instance => _instance;
  Environment._init();

  static String API_VERSION = "v1";

  // https://travel-monkey-app-backend-staging.azurewebsites.net/api/user-auth/v1/user-registration/

  static const String STAGING_BASE_URL = "";

  static const String REMOTE_DEV_BASE_URL =
      "https://e-shop-api-dev.azurewebsites.net/api/";
  static const String PROD_BASE_URL = "";
  static const String LOCAL_DEV_BASE_URL = "http://192.168.1.181:8000/api/";

  String tenant_registration_sub_url =
      "user-auth/$API_VERSION/user-registration/";
  String tenant_validate_account_sub_url =
      "user-auth/$API_VERSION/activate-account/";
  String tenant_login_sub_url = "user-auth/$API_VERSION/token/login/";
  String all_products_sub_url = "products/$API_VERSION/all-products/";
  String product_details_sub_url = "products/$API_VERSION/product-details/";
  String google_signin_sub_url = "authentication/$API_VERSION/google-signin/";
  String user_contact_infos_sub_url =
      "authentication/$API_VERSION/user-contact-infos/";
  String category_list_sub_url = "category/$API_VERSION/mobile-category-list/";
  String token_refresh_sub_url = "authentication/$API_VERSION/token/refresh/";

  static EnvironmentType environmentType = EnvironmentType.remote_dev;

  String get getBaseUrl {
    switch (environmentType) {
      case EnvironmentType.staging:
        return STAGING_BASE_URL;
      case EnvironmentType.prod:
        return PROD_BASE_URL;
      case EnvironmentType.local_dev:
        return LOCAL_DEV_BASE_URL;
      case EnvironmentType.remote_dev:
        return REMOTE_DEV_BASE_URL;
    }
  }

    static  String IMAGE_URL =  (environmentType == EnvironmentType.remote_dev)
      ? "https://e-shop-api-dev.azurewebsites.net"
      : "http://192.168.1.181:8000/"
    
   
}
