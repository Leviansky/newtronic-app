import 'package:get/get.dart';
import 'package:newtronic_app/app/modules/product/bindings/product_binding.dart';
import 'package:newtronic_app/app/modules/product/views/product_view.dart';

import '../../routes/app_pages.dart';

final productPages = [
  GetPage(
    name: Routes.product,
    page: () => const ProductView(),
    binding: ProductBinding(),
    participatesInRootNavigator: true,
    preventDuplicates: true,
  ),
];
