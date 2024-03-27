import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:newtronic_app/app/modules/product/widgets/listtile.dart';

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
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: AppColors.bgGray,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Image.asset(
              "assets/logo-newtronic.png",
              width: 140,
              fit: BoxFit.fill,
            ),
            const Icon(
              Icons.menu,
              size: 24.0,
            ),
          ],
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          //Video player
          AspectRatio(
            aspectRatio: 16 / 9,
            child: Container(
              decoration: const BoxDecoration(
                color: Colors.blue,
              ),
            ),
          ),
          const SizedBox(
            height: 5.0,
          ),
          //Title and description about video
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            width: MediaQuery.of(context).size.width,
            child: const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Management System',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  'Management can be implement in our services',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(
            height: 15.0,
          ),
          //Category
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 5),
            height: 50,
            width: MediaQuery.of(context).size.width,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: 4,
              itemBuilder: (context, index) {
                return Container(
                  height: 25,
                  width: 120,
                  margin: const EdgeInsets.symmetric(horizontal: 5),
                  decoration: const BoxDecoration(
                    color: AppColors.bgGray,
                    borderRadius: BorderRadius.all(
                      Radius.circular(10),
                    ),
                  ),
                  child: const Center(
                    child: Text(
                      'Produk',
                      style: TextStyle(
                        fontSize: 19,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          const SizedBox(
            height: 15.0,
          ),
          //Data List tile
          Expanded(
            child: ListView(
              children: const [
                ListTileProduct(
                  title: 'Management System',
                  subtitle: 'Management can be implement in our services.',
                ),
                ListTileProduct(
                  title: 'ITRF',
                  subtitle: 'Interactive Rasio.',
                ),
                ListTileProduct(
                  title: 'Smart Table System',
                  subtitle:
                      'Solution for your business in queuing system information.',
                ),
                ListTileProduct(
                  title: 'Interactive Walldoor',
                  subtitle: 'Show forex trading chart with flat currency.',
                ),
                ListTileProduct(
                  title: 'LED Display',
                  subtitle: 'Management can be implement in our services.',
                ),
                ListTileProduct(
                  title: 'Queuing Services',
                  subtitle: 'Management can be implement in our services.',
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
