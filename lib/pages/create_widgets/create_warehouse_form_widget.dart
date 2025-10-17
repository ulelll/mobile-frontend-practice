import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mobile_sigma_app/controllers/warehouse_controller.dart';
import 'package:mobile_sigma_app/controllers/address_controller.dart';
import 'package:mobile_sigma_app/controllers/branch_controller.dart'; // Tambahkan ini
import 'package:mobile_sigma_app/widgets/fields/custom_text_field.dart';
import 'package:mobile_sigma_app/widgets/fields/address_dropdowns.dart';
import 'package:mobile_sigma_app/widgets/fields/branch_dropdown.dart'; // Tambahkan ini
import 'package:mobile_sigma_app/widgets/fields/submit_button.dart';

class CreateWarehouseFormWidget extends StatefulWidget {
  const CreateWarehouseFormWidget({super.key});

  @override
  State<CreateWarehouseFormWidget> createState() => _CreateWarehouseFormWidgetState();
}

class _CreateWarehouseFormWidgetState extends State<CreateWarehouseFormWidget> {
  final _formKey = GlobalKey<FormState>();

  final addressController = Get.put(AddressController());
  final warehouseController = Get.put(WarehouseController());
  final branchController = Get.put(BranchController()); // Tambahkan ini

  final nameCtrl = TextEditingController();
  final picNameCtrl = TextEditingController();
  final phoneCtrl = TextEditingController();
  final addressCtrl = TextEditingController();
  final codeCtrl = TextEditingController();
  // Hapus branchIdCtrl karena tidak diperlukan lagi

  final selectedProvince = ''.obs;
  final selectedDistrict = ''.obs;
  final selectedSubdistrict = ''.obs;
  final selectedWard = ''.obs;
  final selectedBranchId = ''.obs; // Tambahkan ini untuk menyimpan branch ID

  @override
  void initState() {
    super.initState();
    // Fetch dropdown data
    addressController.fetchProvinces();
    branchController.fetchBranches(); // Tambahkan ini
  }

  Future<void> _handleSubmit() async {
    if (!_formKey.currentState!.validate()) return;

    final payload = {
      "name": nameCtrl.text.trim(),
      "code_id": codeCtrl.text.trim(),
      "pic_name": picNameCtrl.text.trim(),
      "phone": phoneCtrl.text.trim(),
      "address": addressCtrl.text.trim(),
      "province_id": selectedProvince.value,
      "district_id": selectedDistrict.value,
      "subdistrict_id": selectedSubdistrict.value,
      "ward_id": selectedWard.value,
      "branch_id": selectedBranchId.value, // Gunakan selectedBranchId
    };

    warehouseController.isLoading.value = true;
    final success = await warehouseController.createWarehouse(payload);
    warehouseController.isLoading.value = false;

    if (success) {
      Get.back();
      Get.snackbar(
        'Success',
        'Warehouse created!',
        snackPosition: SnackPosition.TOP,
      );
      warehouseController.fetchWarehouses();
    } else {
      Get.snackbar(
        'Error',
        'Failed to create warehouse.',
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
              CustomTextField(
                label: "Warehouse Name", 
                controller: nameCtrl, 
                required: true
              ),
              CustomTextField(
                label: "Code ID", 
                controller: codeCtrl, 
                required: true
              ),
              CustomTextField(
                label: "PIC Name", 
                controller: picNameCtrl, 
                required: true
              ),
              
              // Ganti TextField dengan Dropdown
              const SizedBox(height: 8),
              BranchDropdown(
                controller: branchController,
                selectedBranchId: selectedBranchId,
                required: true,
              ),
              const SizedBox(height: 8),
              
              CustomTextField(
                label: "Phone Number",
                controller: phoneCtrl,
                keyboardType: TextInputType.phone,
              ),
              CustomTextField(
                label: "Full Address", 
                controller: addressCtrl, 
                maxLines: 3
              ),
              const SizedBox(height: 8),

              AddressDropdowns(
                controller: addressController,
                selectedProvince: selectedProvince,
                selectedDistrict: selectedDistrict,
                selectedSubdistrict: selectedSubdistrict,
                selectedWard: selectedWard,
              ),
              const SizedBox(height: 20),

              SubmitButton(
                text: "Create Warehouse",
                isLoading: warehouseController.isLoading.value,
                onPressed: _handleSubmit,
              ),
            ],
          );
        }),
      ),
    );
  }
}