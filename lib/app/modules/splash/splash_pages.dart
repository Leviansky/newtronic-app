import 'package:get/get.dart';

import '../../routes/app_pages.dart';
import 'bindings/splash_binding.dart';
import 'views/splash_view.dart';

final splashPages = [
  GetPage(
    name: Routes.splash,
    page: () => const SplashView(),
    binding: SplashBinding(),
    participatesInRootNavigator: true,
    preventDuplicates: true,
  )
];
