import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mobile_sigma_app/controllers/category_controller.dart';
import 'custom_dropdown.dart';

class CompanyCategoryDropdown extends StatelessWidget {
  final CategoryController controller;
  final RxString selectedCompanyCategory;

  const CompanyCategoryDropdown({
    super.key,
    required this.controller,
    required this.selectedCompanyCategory,
  });

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      // kalau belum ada data
      if (controller.companyCategories.isEmpty) {
        return const Center(child: CircularProgressIndicator());
      }

      return CustomDropdown(
        label: "Company Category",
        items: controller.companyCategories,
        selectedValue: selectedCompanyCategory.value.isEmpty
            ? null
            : selectedCompanyCategory.value,
        onChanged: (val) {
          selectedCompanyCategory.value = val ?? '';
        },
        itemLabelBuilder: (item) => item['name'],
        required: true,
      );
    });
  }
}
