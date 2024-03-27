import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../resources/colors.dart';
import '../controllers/product_controller.dart';

class ProductView extends StatefulWidget {
  const ProductView({Key? key}) : super(key: key);

  @override
  State<ProductView> createState() => _ProductViewState();
}

class _ProductViewState extends State<ProductView> {
  final controller = Get.put(ProductController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primary,
      appBar: AppBar(
        title: Text('Example'),
      ),
      body: Text('Example'),
    );
  }
}
