import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mobile_sigma_app/controllers/company_controller.dart';
import 'package:mobile_sigma_app/controllers/address_controller.dart';
import 'package:mobile_sigma_app/controllers/details page/company_detail_controller.dart';
import 'package:mobile_sigma_app/controllers/category_controller.dart';
import 'package:mobile_sigma_app/widgets/fields/custom_text_field.dart';
import 'package:mobile_sigma_app/widgets/fields/address_dropdowns.dart';
import 'package:mobile_sigma_app/widgets/fields/submit_button.dart';
import 'package:mobile_sigma_app/widgets/fields/category_company_dropdown.dart';

class CompanyFormWidget extends StatefulWidget {
  final bool isEdit;
  final String? companyId;

  const CompanyFormWidget({
    super.key,
    this.isEdit = false,
    this.companyId,
  });

  @override
  State<CompanyFormWidget> createState() => _CompanyFormWidgetState();
}

class _CompanyFormWidgetState extends State<CompanyFormWidget> {
  final _formKey = GlobalKey<FormState>();

  final addressController = Get.put(AddressController());
  final categoryController = Get.put(CategoryController());
  final companyController = Get.put(CompanyController());
  final companyDetailController = Get.put(CompanyDetailController());

  final nameCtrl = TextEditingController();
  final picNameCtrl = TextEditingController();
  final phoneCtrl = TextEditingController();
  final addressCtrl = TextEditingController();
  final codeCtrl = TextEditingController();

  final selectedProvince = ''.obs;
  final selectedDistrict = ''.obs;
  final selectedSubdistrict = ''.obs;
  final selectedWard = ''.obs;
  final selectedCategory = ''.obs;

  @override
  void initState() {
    super.initState();
    // Fetch dropdown data
    addressController.fetchProvinces();
    categoryController.fetchCompanyCategories(); // ✅ fetch categories too

    // If edit mode, load existing company data
    if (widget.isEdit && widget.companyId != null) {
      _loadCompanyData(widget.companyId!);
    }
  }

  Future<void> _loadCompanyData(String id) async {
    await companyDetailController.fetchCompanyDetail(id);
    final data = companyDetailController.companyData.value;

    if (data != null) {
      nameCtrl.text = data['name'] ?? '';
      picNameCtrl.text = data['pic_name'] ?? '';
      phoneCtrl.text = data['phone'] ?? '';
      addressCtrl.text = data['address'] ?? '';
      codeCtrl.text = data['code_id'] ?? '';

      selectedProvince.value = data['province_id']?.toString() ?? '';
      selectedDistrict.value = data['district_id']?.toString() ?? '';
      selectedSubdistrict.value = data['subdistrict_id']?.toString() ?? '';
      selectedWard.value = data['ward_id']?.toString() ?? '';
      selectedCategory.value = data['category_id']?.toString() ?? '';
    }
  }

  Future<void> _handleSubmit() async {
    if (!_formKey.currentState!.validate()) return;

    final payload = {
      "name": nameCtrl.text.trim(),
      "code_id": codeCtrl.text.trim(),
      "pic_name": picNameCtrl.text.trim(),
      "phone": phoneCtrl.text.trim(),
      "category_id": selectedCategory.value, 
      "address": addressCtrl.text.trim(),
      "province_id": selectedProvince.value,
      "district_id": selectedDistrict.value,
      "subdistrict_id": selectedSubdistrict.value,
      "ward_id": selectedWard.value,
    };

    bool success;
    companyController.isLoading.value = true;

    if (widget.isEdit && widget.companyId != null) {
      success = await companyController.updateCompany(widget.companyId!, payload);
    } else {
      success = await companyController.createCompany(payload);
    }

    companyController.isLoading.value = false;

    if (success) {
      Get.back();
      Get.snackbar(
        'Success',
        widget.isEdit ? 'Company updated!' : 'Company created!',
        snackPosition: SnackPosition.TOP,
      );
      companyController.fetchCompanies();
    } else {
      Get.snackbar(
        'Error',
        'Failed to save company.',
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
              CustomTextField(label: "Company Name", controller: nameCtrl, required: true),
              CustomTextField(label: "Code ID", controller: codeCtrl, required: true),
              CustomTextField(label: "PIC Name", controller: picNameCtrl, required: true),
              CustomTextField(
                label: "Phone Number",
                controller: phoneCtrl,
                keyboardType: TextInputType.phone,
              ),
              CustomTextField(label: "Full Address", controller: addressCtrl, maxLines: 3),
              const SizedBox(height: 8),

              // 🏙 Address Dropdowns
              AddressDropdowns(
                controller: addressController,
                selectedProvince: selectedProvince,
                selectedDistrict: selectedDistrict,
                selectedSubdistrict: selectedSubdistrict,
                selectedWard: selectedWard,
              ),
              const SizedBox(height: 20),

              CompanyCategoryDropdown(
                controller: categoryController,
                selectedCompanyCategory: selectedCategory,
              ),
              const SizedBox(height: 20),

              // 💾 Submit button
              SubmitButton(
                text: widget.isEdit ? "Update Company" : "Create Company",
                isLoading: companyController.isLoading.value,
                onPressed: _handleSubmit,
              ),
            ],
          );
        }),
      ),
    );
  }
}
