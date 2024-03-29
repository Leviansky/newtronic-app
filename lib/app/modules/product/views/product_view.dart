import 'dart:io';
import 'dart:isolate';
import 'dart:ui';

import 'package:flick_video_player/flick_video_player.dart';
import 'package:flutter/material.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:get/get.dart';
import 'package:newtronic_app/app/modules/product/widgets/card_category.dart';
import 'package:newtronic_app/app/modules/product/widgets/listtile_playlist.dart';
import 'package:newtronic_app/app/modules/product/widgets/loading.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:video_player/video_player.dart';
import '../../../../resources/colors.dart';
import '../controllers/product_controller.dart';

class ProductView extends StatefulWidget {
  const ProductView({Key? key}) : super(key: key);

  @override
  State<ProductView> createState() => _ProductViewState();
}

class _ProductViewState extends State<ProductView> {
  final controller = Get.put(ProductController());
  late FlickManager flickManager;
  final ReceivePort _port = ReceivePort();

  @override
  void initState() {
    super.initState();
    controller.init();

    Permission.storage.request();

    IsolateNameServer.registerPortWithName(
        _port.sendPort, 'downloader_send_port');
    _port.listen((dynamic data) {
      String id = data[0];
      DownloadTaskStatus status = data[1];
      int progress = data[2];
      setState(() {});
    });

    FlutterDownloader.registerCallback(downloadCallback);
  }

  @override
  void dispose() {
    controller.videoPlayer.dispose();
    IsolateNameServer.removePortNameMapping('downloader_send_port');
    super.dispose();
  }

  @pragma('vm:entry-point')
  static void downloadCallback(String id, int status, int progress) {
    final SendPort? send =
        IsolateNameServer.lookupPortByName('downloader_send_port');
    send?.send([id, status, progress]);
  }

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
          //CONTENT PLAYER
          ContentPlayer(controller: controller),
          const SizedBox(
            height: 5.0,
          ),
          //TITLE AND DESCRIPTION OF CONTENT
          ContentDescription(controller: controller),
          const SizedBox(
            height: 15.0,
          ),
          //LIST PRODUCTS
          ProductList(controller: controller),
          const SizedBox(
            height: 15.0,
          ),
          //LIST PLAYLIST
          ContentPlaylist(controller: controller),
        ],
      ),
    );
  }
}

class ContentPlaylist extends StatelessWidget {
  const ContentPlaylist({
    super.key,
    required this.controller,
  });

  final ProductController controller;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Obx(
        () => ListView.builder(
          itemCount: controller.listPlaylist.length,
          itemBuilder: (context, index) {
            return Obx(
              () => ListTilePlaylist(
                index: index,
                controller: controller,
                title: controller.listPlaylist[index].title!,
                subtitle: controller.listPlaylist[index].description!,
                url: controller.listPlaylist[index].url!,
                type: controller.listPlaylist[index].type!,
              ),
            );
          },
        ),
      ),
    );
  }
}

class ProductList extends StatelessWidget {
  const ProductList({
    super.key,
    required this.controller,
  });

  final ProductController controller;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 5),
      height: 50,
      width: MediaQuery.of(context).size.width,
      child: Obx(
        () => ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: controller.listProducts.length,
          itemBuilder: (context, index) {
            return Obx(
              () => CardProduct(
                index: index,
                controller: controller,
                title: controller.listProducts[index].title!,
                isSelected: controller.selectedIndexProduct.value == index,
              ),
            );
          },
        ),
      ),
    );
  }
}

class ContentDescription extends StatelessWidget {
  const ContentDescription({
    super.key,
    required this.controller,
  });

  final ProductController controller;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      width: MediaQuery.of(context).size.width,
      child: Obx(
        () => Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              controller.title.value,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              controller.subtitle.value,
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w400,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ContentPlayer extends StatelessWidget {
  const ContentPlayer({
    super.key,
    required this.controller,
  });

  final ProductController controller;

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 16 / 9,
      child: Obx(() {
        if (controller.isLoading.value) {
          return const LoadingIndicator();
        } else {
          // SHOW VIDEO IF TYPE OF SELECTED CONTENT IS VIDEO
          if (controller.selectedContentType.value == ContentTypeKeys.video) {
            return VideoView(controller: controller);
          }
          // SHOW IMAGE IF TYPE OF SELECTED CONTENT IS IMAGE
          else if (controller.selectedContentType.value ==
              ContentTypeKeys.image) {
            return ImageView(controller: controller);
          } else {
            return Container(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: const Center(
                child: Text(
                  "Please reconnect or change your connection as the API link used is a Public IP ☠️",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            );
          }
        }
      }),
    );
  }
}

class VideoView extends StatelessWidget {
  const VideoView({
    Key? key,
    required this.controller,
  }) : super(key: key);

  final ProductController controller;

  @override
  Widget build(BuildContext context) {
    return Obx(
      () {
        if (controller.isFileDownloaded.value) {
          return FlickVideoPlayer(
            key: UniqueKey(),
            flickManager: controller.videoPlayer,
          );
        } else {
          return FlickVideoPlayer(
            key: UniqueKey(),
            flickManager: controller.videoPlayer,
          );
        }
      },
    );
  }
}

class ImageView extends StatelessWidget {
  const ImageView({
    super.key,
    required this.controller,
  });

  final ProductController controller;

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => controller.isFileDownloaded.value
          ? FutureBuilder<String>(
              future: Future<String>.value(controller.directoryFile.value),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                } else {
                  final filePath = snapshot.data!;
                  final file = File(filePath);
                  if (file.existsSync()) {
                    return Image.file(
                      file,
                      height: double.infinity,
                      width: MediaQuery.of(context).size.width,
                      fit: BoxFit.cover,
                    );
                  } else {
                    return const Center(
                      child: Text('File not found'),
                    );
                  }
                }
              },
            )
          : Obx(
              () => Image.network(
                controller.url.value,
                height: double.infinity,
                width: MediaQuery.of(context).size.width,
                fit: BoxFit.cover,
                loadingBuilder: (context, child, loadingProgress) {
                  if (loadingProgress == null) {
                    return child;
                  } else {
                    return LoadingIndicator(
                      value: loadingProgress.expectedTotalBytes != null
                          ? loadingProgress.cumulativeBytesLoaded /
                              loadingProgress.expectedTotalBytes!
                          : null,
                    );
                  }
                },
              ),
            ),
    );
  }
}
