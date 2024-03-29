// ignore_for_file: avoid_print
import 'dart:ffi';
import 'dart:io';

import 'package:flick_video_player/flick_video_player.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
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
  final selectedIndexContent = 0.obs;
  final isLoading = false.obs;
  final isLoadingDownload = false.obs;
  final isFileDownloaded = false.obs;
  final directoryFile = ''.obs;
  final progressDownload = 0.0.obs;

  final Rx<ResponseProduct> responseAPI = ResponseProduct().obs;
  final listProducts = RxList<Product>();
  final listPlaylist = RxList<Playlist>();
  final RxList<bool> isLoadingPlaylist = <bool>[].obs;

  late FlickManager videoPlayer;

  init() {
    getAllResponse();
  }

  void initializeLoadingList(int length) {
    isLoadingPlaylist.assignAll(List<bool>.filled(length, false));
  }

  void changeLoadingStatus(int index, bool value) {
    isLoadingPlaylist[index] = value;
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

      initializeLoadingList(listProducts[newest].playlist!.length);

      checkFile(url.value);
      isLoading.value = false;
    } catch (e) {
      print(e);
      isLoading.value = false;
    }
  }

  void changeProduct(int selectedIndex) async {
    try {
      isLoading.value = true;
      checkFile(listPlaylist[newest].url!);

      // CHECK IF DATA IS VIDEO AND PLAYING, PAUSE VIDEO WHEN TRUE
      if (selectedContentType.value == ContentTypeKeys.video &&
          videoPlayer.flickVideoManager!.isPlaying) {
        videoPlayer.flickControlManager!.autoPause();
      }

      // SAVE VARIABLES WITH NEW DATAS
      selectedIndexProduct.value = selectedIndex;
      selectedIndexContent.value = newest;
      listPlaylist.value = listProducts[selectedIndex].playlist!;
      title.value = listPlaylist[newest].title!;
      subtitle.value = listPlaylist[newest].description!;
      url.value = listPlaylist[newest].url!;
      selectedContentType.value = listPlaylist[newest].type!;

      initializeLoadingList(listProducts[selectedIndex].playlist!.length);
    } catch (e) {
      print('Error while changing selected product: $e');
    } finally {
      isLoading.value = false;
    }
  }

  void changeSelected(int selectedIndex) async {
    try {
      isLoading.value = true;

      // CHECK IF DATA IS VIDEO AND PLAYING, PAUSE VIDEO WHEN TRUE
      if (selectedContentType.value == ContentTypeKeys.video &&
          videoPlayer.flickVideoManager!.isPlaying) {
        videoPlayer.flickControlManager!.autoPause();
      }

      // SAVE VARIABLES WITH NEW DATAS
      selectedIndexContent.value = selectedIndex;
      selectedContentType.value = listPlaylist[selectedIndex].type!;
      title.value = listPlaylist[selectedIndex].title!;
      subtitle.value = listPlaylist[selectedIndex].description!;
      url.value = listPlaylist[selectedIndex].url!;

      checkFile(url.value);
    } catch (e) {
      print('Error while changing selected: $e');
    } finally {
      isLoading.value = false;
    }
  }

  void initializeVideoFromUrl(String url) {
    try {
      videoPlayer = FlickManager(
        videoPlayerController: VideoPlayerController.networkUrl(
          Uri.parse(url),
        ),
        autoPlay: false,
      );
    } catch (e) {
      print(e);
    }
  }

  void initializeVideoFromPath(String path) {
    try {
      videoPlayer = FlickManager(
        videoPlayerController: VideoPlayerController.file(
          File(path),
        ),
        autoPlay: false,
      );
    } catch (e) {
      print(e);
    }
  }

  Future<bool?> download(String url) async {
    try {
      print(url);
      isLoadingDownload.value = true;
      progressDownload.value = 0;

      await Future.delayed(const Duration(seconds: 2), () {
        isLoadingDownload.value = false;
      });

      return false;
      // // DOWNLOAD INITIATION
      // final baseStorage = await getExternalStorageDirectory();
      // await FlutterDownloader.enqueue(
      //   url: url,
      //   headers: {},
      //   savedDir: baseStorage!.path,
      //   showNotification: true,
      //   openFileFromNotification: true,
      // );
    } catch (e) {
      print(e);
    }
    return null;
    // finally {
    //   isLoadingDownload.value = false;
    // }
  }

  void checkFile(String url) async {
    try {
      var fileName = url.split('/').last;
      final isFileExists = await network.isFileExists(fileName);
      isFileDownloaded.value = isFileExists;

      // GET PATH OF FILE
      Directory? baseStorage = await getExternalStorageDirectory();
      String directoryFilePath = baseStorage?.path ?? '';
      directoryFile.value = '$directoryFilePath/$fileName';

      // INITIALIZE VIDEO
      if (isFileExists) {
        if (selectedContentType.value == ContentTypeKeys.video) {
          initializeVideoFromPath(directoryFile.value);
        }
      } else {
        if (selectedContentType.value == ContentTypeKeys.video) {
          initializeVideoFromUrl(url);
        }
      }
    } catch (e) {
      print(e);
    }
  }
}
