import 'package:flutter/material.dart';
import 'package:newtronic_app/app/modules/product/controllers/product_controller.dart';
import 'package:newtronic_app/resources/colors.dart';

class CardProduct extends StatelessWidget {
  const CardProduct({
    super.key,
    required this.index,
    required this.title,
    required this.controller,
    required this.isSelected,
  });

  final int index;
  final String title;
  final ProductController controller;
  final bool isSelected;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        controller.changeProduct(index);
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 25),
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
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: isSelected ? Colors.white : Colors.black,
            ),
          ),
        ),
      ),
    );
  }
}
