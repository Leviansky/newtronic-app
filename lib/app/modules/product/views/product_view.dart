import 'package:flick_video_player/flick_video_player.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:newtronic_app/app/modules/product/widgets/card_category.dart';
import 'package:newtronic_app/app/modules/product/widgets/listtile_playlist.dart';
import 'package:newtronic_app/app/modules/product/widgets/loading.dart';
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

  @override
  void initState() {
    super.initState();
    controller.init();
  }

  @override
  void dispose() {
    controller.videoPlayer.dispose();
    super.dispose();
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
          //Content player
          ContentPlayer(controller: controller),
          const SizedBox(
            height: 5.0,
          ),
          //Title and description about video
          ContentDescription(controller: controller),
          const SizedBox(
            height: 15.0,
          ),
          //List Products
          ProductList(controller: controller),
          const SizedBox(
            height: 15.0,
          ),
          //List Tile Playlist
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
          if (controller.selectedContentType.value == ContentTypeKeys.video) {
            return FlickVideoPlayer(flickManager: controller.videoPlayer);
          } else if (controller.selectedContentType.value ==
              ContentTypeKeys.image) {
            return ImageView(controller: controller);
          } else {
            return const Text(
              'Nothing here',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            );
          }
        }
      }),
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
    return Image.network(
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
    );
  }
}
