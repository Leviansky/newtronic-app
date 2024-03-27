import 'package:flutter/material.dart';
import 'package:newtronic_app/app/modules/product/controllers/product_controller.dart';
import 'package:newtronic_app/resources/colors.dart';

class CardProduct extends StatelessWidget {
  const CardProduct({
    super.key,
    required this.controller,
    required this.title,
    required this.isSelected,
    required this.index,
  });

  final String title;
  final ProductController controller;
  final bool isSelected;
  final int index;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        controller.changeProduct(index);
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        margin: const EdgeInsets.symmetric(horizontal: 5),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primary : AppColors.bgGray,
          borderRadius: const BorderRadius.all(
            Radius.circular(10),
          ),
        ),
        child: Center(
          child: Text(
            title,
            style: TextStyle(
              fontSize: 19,
              fontWeight: FontWeight.bold,
              color: isSelected ? Colors.white : Colors.black,
            ),
          ),
        ),
      ),
    );
  }
}
