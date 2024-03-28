// ignore_for_file: avoid_print
import 'dart:io';

import 'package:flick_video_player/flick_video_player.dart';
import 'package:get/get.dart';
import 'package:newtronic_app/app/models/playlist.dart';
import 'package:newtronic_app/app/models/product.dart';
import 'package:newtronic_app/app/models/response.dart';
import 'package:newtronic_app/app/modules/product/repositories/product_repository.dart';
import 'package:path_provider/path_provider.dart';
import 'package:video_player/video_player.dart';

class ContentTypeKeys {
  static const String video = 'video';
  static const String image = 'image';
  static const String any = 'any';
}

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
  final isFileDownloaded = false.obs;
  final directoryFile = ''.obs;

  final Rx<ResponseProduct> responseAPI = ResponseProduct().obs;
  final listProducts = RxList<Product>();
  final listPlaylist = RxList<Playlist>();

  late FlickManager videoPlayer;

  init() {
    getAllResponse();
  }

  void getAllResponse() async {
    try {
      isLoading.value = true;
      //GET DATAS FROM API
      final response = await network.getAllResponse();
      responseAPI.value = response!;
      //SAVE RESPONSE WITH VARIABLE
      listProducts.value = responseAPI.value.data!;
      listPlaylist.value = listProducts[newest].playlist!;
      title.value = listPlaylist[newest].title!;
      subtitle.value = listPlaylist[newest].description!;
      url.value = listPlaylist[newest].url!;
      selectedContentType.value = listPlaylist[newest].type!;
      checkFile(url.value);
      isLoading.value = false;
    } catch (e) {
      print(e);
    }
  }

  void changeProduct(selectedIndex) async {
    isLoading.value = true;
    checkFile(listPlaylist[newest].url!);
    //CHECK IS VIDEO PLAYING OR NOT
    // if (selectedContentType.value == ContentTypeKeys.video) {
    //   videoPlayer.flickControlManager?.autoPause();
    // }
    //SAVE VARIABLES WITH NEW DATA
    selectedIndexProduct.value = selectedIndex;
    listPlaylist.value = listProducts[selectedIndex].playlist!;
    title.value = listPlaylist[newest].title!;
    subtitle.value = listPlaylist[newest].description!;
    url.value = listPlaylist[newest].url!;
    selectedContentType.value = listPlaylist[newest].type!;
    //INITIALIZE IF THE TYPE OF DATA IS VIDEO
    if (selectedContentType.value == ContentTypeKeys.video) {
      initializeVideoFromUrl(url.value);
    }
    isLoading.value = false;
  }

  void changeSelected(selectedIndex) async {
    isLoading.value = true;
    checkFile(listPlaylist[selectedIndex].url!);
    //CHECK IS VIDEO PLAYING OR NOT
    // if (selectedContentType.value == ContentTypeKeys.video) {
    //   videoPlayer.flickControlManager?.autoPause();
    // }
    //SAVE VARIABLES WITH NEW DATA
    title.value = listPlaylist[selectedIndex].title!;
    subtitle.value = listPlaylist[selectedIndex].description!;
    url.value = listPlaylist[selectedIndex].url!;
    selectedContentType.value = listPlaylist[selectedIndex].type!;

    print(url.value);

    isLoading.value = false;
  }

  void initializeVideoFromUrl(url) {
    videoPlayer = FlickManager(
      videoPlayerController: VideoPlayerController.networkUrl(
        Uri.parse(url),
      ),
      autoPlay: false,
    );
  }

  void initializeVideoFromPath(path) {
    videoPlayer = FlickManager(
      videoPlayerController: VideoPlayerController.file(
        File(path),
      ),
      autoPlay: false,
    );
  }

  void download(url) async {
    try {
      print(url);
      final response = await network.downloadFile(url: url);
      print(response);
    } catch (e) {
      print(e);
    }
  }

  void checkFile(url) async {
    try {
      var fileName = url.split('/').last;
      final response = await network.isFileExists(fileName);
      isFileDownloaded.value = response;

      Directory? baseStorage = await getExternalStorageDirectory();
      String directoryFilePath = baseStorage?.path ?? '';
      directoryFile.value = '$directoryFilePath/$fileName';

      print('=================');
      print(isFileDownloaded.value);
      print(directoryFile.value);
      print(url);
    } catch (e) {
      print(e);
    }
  }
}
