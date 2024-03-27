// ignore_for_file: avoid_print
import 'package:flick_video_player/flick_video_player.dart';
import 'package:get/get.dart';
import 'package:newtronic_app/app/models/playlist.dart';
import 'package:newtronic_app/app/models/product.dart';
import 'package:newtronic_app/app/models/response.dart';
import 'package:newtronic_app/app/modules/product/repositories/product_repository.dart';
import 'package:http/http.dart' as http;
import 'package:video_player/video_player.dart';

class ProductController extends GetxController {
  static ProductController get to => Get.find();
  final network = ProductRepository();
  int newest = 0;

  final title = ''.obs;
  final subtitle = ''.obs;
  final url = ''.obs;
  final selectedContentType = ''.obs;
  final selectedIndexProduct = 0.obs;
  final isLoading = false.obs;

  final Rx<ResponseProduct> responseAPI = ResponseProduct().obs;
  final listProducts = RxList<Product>();
  final listPlaylist = RxList<Playlist>();

  late FlickManager videoPlayer;

  init() {
    isLoading.value = true;
    getAllResponse();
  }

  void getAllResponse() async {
    try {
      final response = await network.getAllResponse();
      responseAPI.value = response!;
      listProducts.value = responseAPI.value.data!;
      listPlaylist.value = listProducts[newest].playlist!;
      title.value = listPlaylist[newest].title!;
      subtitle.value = listPlaylist[newest].description!;
      url.value = listPlaylist[newest].url!;
      checkContentType(url.value);
      print(url.value);
    } catch (e) {
      print(e);
    }
  }

  void changeProduct(selectedIndex) async {
    isLoading.value = true;
    selectedIndexProduct.value = selectedIndex;
    listPlaylist.value = listProducts[selectedIndex].playlist!;
    title.value = listPlaylist[newest].title!;
    subtitle.value = listPlaylist[newest].description!;
    url.value = listPlaylist[newest].url!;
    checkContentType(url.value);
  }

  void changeSelected(selectedIndex) async {
    isLoading.value = true;
    title.value = listPlaylist[selectedIndex].title!;
    subtitle.value = listPlaylist[selectedIndex].description!;
    url.value = listPlaylist[selectedIndex].url!;
    print(url.value);
    checkContentType(url.value);
  }

  void checkContentType(String url) async {
    try {
      final response = await http.head(Uri.parse(url));
      if (response.headers.containsKey('content-type')) {
        final contentType = response.headers['content-type']!;
        print(contentType);
        if (contentType.startsWith('image/')) {
          selectedContentType.value = 'image';
          isLoading.value = false;
        } else {
          selectedContentType.value = 'video';
          videoPlayer = FlickManager(
            videoPlayerController: VideoPlayerController.networkUrl(
              Uri.parse(url),
            ),
            autoPlay: false,
          );
          isLoading.value = false;
        }
      }
    } catch (e) {
      print('Error: $e');
    }
    return null;
  }
}
