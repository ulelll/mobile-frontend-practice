import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mobile_sigma_app/controllers/branch_controller.dart';
import 'package:mobile_sigma_app/controllers/product_controller.dart';
import 'package:mobile_sigma_app/controllers/category_controller.dart';
import 'package:mobile_sigma_app/controllers/warehouse_controller.dart';
import 'package:mobile_sigma_app/widgets/fields/branch_dropdown.dart';
import 'package:mobile_sigma_app/widgets/fields/category_products_dropdown.dart';
import 'package:mobile_sigma_app/widgets/fields/custom_text_field.dart';
import 'package:mobile_sigma_app/widgets/fields/submit_button.dart';


class CreateProductFormWidget extends StatefulWidget {
  const CreateProductFormWidget({super.key});

  @override
  State<CreateProductFormWidget> createState() => _CreateProductFormWidgetState();
}

class _CreateProductFormWidgetState extends State<CreateProductFormWidget> {
  final _formKey = GlobalKey<FormState>();

  final categoryController = Get.put(CategoryController());
  final productController = Get.put(ProductController());
  final warehouseController = Get.put(WarehouseController());
  final branchController = Get.put(BranchController());

  final nameCtrl = TextEditingController();
  final descriptionCtrl = TextEditingController();
  final codeCtrl = TextEditingController();
  final noteCtrl =TextEditingController();

  final selectedBranchId = ''.obs;
  final selectedWarehouseId = ''.obs;
  final selectedCategory = ''.obs;

  @override
  void initState() {
    super.initState();
    branchController.fetchBranches();
    categoryController.fetchProductCategories(); // load categories
    warehouseController.fetchWarehouses(); // 
  }

  Future<void> _handleSubmit() async {
    if (!_formKey.currentState!.validate()) return;

    final payload = {
      "name": nameCtrl.text.trim(),
      "code_id": codeCtrl.text.trim(),
      "description": descriptionCtrl.text.trim(),
      "note": noteCtrl.text.trim(),
      "category_id": selectedCategory.value,
      "branch_id": selectedBranchId.value,
      "warehouse_id": selectedBranchId.value,

    };

    productController.isLoading.value = true;
    final success = await productController.createProduct(payload);
    productController.isLoading.value = false;

    if (success) {
      Get.back();
      Get.snackbar(
        'Success',
        'Company created!',
        snackPosition: SnackPosition.TOP,
      );
      productController.fetchProducts();
    } else {
      Get.snackbar(
        'Error',
        'Failed to create product.',
        snackPosition: SnackPosition.TOP,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Obx(() {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CustomTextField(label: "Product Name", controller: nameCtrl, required: true),
              const SizedBox(height: 8),
              CustomTextField(label: "Code ID", controller: codeCtrl, required: true),
              const SizedBox(height: 8),
              ProductCategoryDropdown(controller: categoryController, selectedProductCategory: selectedCategory,), //category
              const SizedBox(height: 8),
              BranchDropdown(controller: branchController,selectedBranchId: selectedBranchId, required: true ), //branch
              const SizedBox(height: 8),
              CustomTextField(label: "Description", controller: descriptionCtrl, required: true),
              const SizedBox(height: 8),
              CustomTextField(label: "Note", controller: noteCtrl, required: true),
              SubmitButton(
                text: "Create product",
                isLoading: productController.isLoading.value,
                onPressed: _handleSubmit,
              ),
            ],
          );
        }),
      ),
    );
  }
}
