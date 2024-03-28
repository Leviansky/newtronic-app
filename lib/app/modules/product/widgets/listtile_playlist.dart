import 'package:flutter/material.dart';
import 'package:newtronic_app/app/modules/product/controllers/product_controller.dart';
import 'package:newtronic_app/resources/colors.dart';

class ListTilePlaylist extends StatelessWidget {
  const ListTilePlaylist({
    super.key,
    required this.index,
    required this.title,
    required this.controller,
    required this.subtitle,
    required this.url,
  });

  final int index;
  final String title;
  final ProductController controller;
  final String subtitle;
  final String url;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        controller.changeSelected(index);
      },
      child: Card(
        color: Colors.white,
        child: ListTile(
          tileColor: Colors.white,
          shape: RoundedRectangleBorder(
            side: const BorderSide(color: Colors.black, width: 1),
            borderRadius: BorderRadius.circular(5),
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
          trailing: GestureDetector(
            onTap: () {
              controller.download(url);
            },
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
              decoration: const BoxDecoration(
                color: AppColors.primary,
                borderRadius: BorderRadius.all(
                  Radius.circular(8),
                ),
              ),
              child: const Text(
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
      ),
    );
  }
}
