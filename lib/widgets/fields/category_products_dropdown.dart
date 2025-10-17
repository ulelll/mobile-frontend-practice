import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mobile_sigma_app/controllers/category_controller.dart';
import 'custom_dropdown.dart';

class ProductCategoryDropdown extends StatelessWidget {
  final CategoryController controller;
  final RxString selectedProductCategory;

  const ProductCategoryDropdown({
    super.key,
    required this.controller,
    required this.selectedProductCategory,
  });

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (controller.productCategories.isEmpty) {
        return const SizedBox(); 
      }

      return CustomDropdown(
        label: "Product Category",
        items: controller.productCategories,
        selectedValue: selectedProductCategory.value.isEmpty
            ? null
            : selectedProductCategory.value,
        onChanged: (val) {
          selectedProductCategory.value = val ?? '';
        },
        itemLabelBuilder: (item) => item['name'],
        required: true,
      );
    });
  }
}
