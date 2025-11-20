import 'commons/main_commons.dart' as commons;
import 'core/main_core.dart' as core;
import 'features/auth/main_auth.dart' as auth;
import 'features/dashboard/main_dashboard.dart' as dashboard;
import 'features/payments/main_payments.dart' as payments;
import 'features/product/main_product.dart' as product;
import 'features/splash/main_splash.dart' as splash;
import 'routes/app_router_test.dart' as app_routes;

void main() {
  commons.main();
  core.main();
  auth.main();
  dashboard.main();
  payments.main();
  product.main();
  splash.main();
  app_routes.main();
}
