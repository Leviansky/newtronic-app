// ignore_for_file: avoid_print

import 'package:get/get.dart';
import 'package:newtronic_app/app/models/playlist.dart';
import 'package:newtronic_app/app/models/product.dart';
import 'package:newtronic_app/app/models/response.dart';
import 'package:newtronic_app/app/modules/product/repositories/product_repository.dart';

class ProductController extends GetxController {
  static ProductController get to => Get.find();
  final network = ProductRepository();

  final title = ''.obs;
  final subtitle = ''.obs;
  final urlVideo = ''.obs;
  final selectedIndexProduct = 0.obs;

  final Rx<ResponseProduct> responseAPI = ResponseProduct().obs;
  final listProducts = RxList<Product>();
  final listPlaylist = RxList<Playlist>();

  init() {
    getAllResponse();
  }

  void getAllResponse() async {
    try {
      final response = await network.getAllResponse();
      responseAPI.value = response!;
      listProducts.value = responseAPI.value.data!;
      listPlaylist.value = listProducts[0].playlist!;
      title.value = listPlaylist[0].title!;
      subtitle.value = listPlaylist[0].description!;
    } catch (e) {
      print(e);
    }
  }

  void changeProduct(index) async {
    selectedIndexProduct.value = index;
    listPlaylist.value = listProducts[index].playlist!;
    title.value = listPlaylist[0].title!;
    subtitle.value = listPlaylist[0].description!;
  }
}
