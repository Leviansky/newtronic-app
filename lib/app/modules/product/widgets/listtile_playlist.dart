import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:newtronic_app/app/modules/product/controllers/product_controller.dart';
import 'package:newtronic_app/app/modules/product/repositories/product_repository.dart';
import 'package:newtronic_app/app/modules/product/widgets/error.dart';
import 'package:newtronic_app/resources/colors.dart';

class ListTilePlaylist extends StatelessWidget {
  ListTilePlaylist({
    super.key,
    required this.index,
    required this.title,
    required this.controller,
    required this.subtitle,
    required this.url,
    required this.type,
  });

  final int index;
  final String title;
  final ProductController controller;
  final String subtitle;
  final String url;
  final String type;

  final repo = Get.put(ProductRepository());

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => GestureDetector(
        onTap: () {
          controller.changeSelected(index);
        },
        child: Card(
          color: controller.selectedIndexContent.value == index
              ? AppColors.primary.withOpacity(0.2)
              : Colors.white,
          child: ListTile(
            tileColor: controller.selectedIndexContent.value == index
                ? AppColors.primary.withOpacity(0.2)
                : Colors.white,
            shape: RoundedRectangleBorder(
              side: const BorderSide(color: Colors.black, width: 1),
              borderRadius: BorderRadius.circular(10),
            ),
            leading: const SizedBox(
              height: double.infinity,
              child: Icon(
                Icons.play_circle_fill,
                size: 40,
              ),
            ),
            title: Text(
              title,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            subtitle: Text(
              subtitle,
              style: const TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.w400,
              ),
            ),
            trailing: FutureBuilder<bool>(
              future: repo.isFileExists(url.split('/').last),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const CircularProgressIndicator(
                    color: Colors.black,
                    strokeWidth: 1,
                  );
                } else {
                  if (snapshot.hasError) {
                    return const ErrorText();
                  } else {
                    return GestureDetector(
                      onTap: () async {
                        if (controller.isLoadingPlaylist[index]) return;
                        if (snapshot.data!) return;
                        controller.changeLoadingStatus(index, true);
                        await controller.download(url).then((value) =>
                            controller.changeLoadingStatus(index, value!));
                      },
                      child: Container(
                        height: 20,
                        width: 70,
                        decoration: BoxDecoration(
                          color: type == ContentTypeKeys.video
                              ? AppColors.primary
                              : AppColors.secondary,
                          borderRadius: const BorderRadius.all(
                            Radius.circular(8),
                          ),
                        ),
                        child: Center(
                          child: Obx(
                            () => controller.isLoadingPlaylist[index]
                                ? const SizedBox(
                                    height: 10,
                                    width: 10,
                                    child: CircularProgressIndicator(
                                      color: Colors.white,
                                      strokeWidth: 1,
                                    ),
                                  )
                                : snapshot.data!
                                    ? controller.selectedIndexContent.value ==
                                            index
                                        ? const Text(
                                            'Hapus',
                                            style: TextStyle(
                                              fontSize: 10,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.black,
                                            ),
                                          )
                                        : const Text(
                                            'Tersimpan',
                                            style: TextStyle(
                                              fontSize: 10,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.white,
                                            ),
                                          )
                                    : const Text(
                                        'Simpan',
                                        style: TextStyle(
                                          fontSize: 10,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white,
                                        ),
                                      ),
                          ),
                        ),
                      ),
                    );
                  }
                }
              },
            ),
          ),
        ),
      ),
    );
  }
}
