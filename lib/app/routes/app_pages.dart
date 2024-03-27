import 'package:newtronic_app/app/modules/product/product_pages.dart';
import 'package:newtronic_app/app/modules/splash/splash_pages.dart';

part 'app_routes.dart';

class AppPages {
  AppPages._();

  static const initial = Routes.splash;

  static final routes = [
    ...splashPages,
    ...productPages,
  ];
}
