import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mobile_sigma_app/api/api_service.dart';
import 'package:mobile_sigma_app/controllers/company_controller.dart';

class CompanyDetailController extends GetxController {
  var companyData = Rxn<Map<String, dynamic>>();
  var isLoading = false.obs;
  var isDeleting = false.obs;
  var errorMessage = ''.obs;

  // Fetch company detail
  Future<void> fetchCompanyDetail(String companyId) async {
    try {
      isLoading.value = true;
      errorMessage.value = '';

      final data = await ApiService.getCompanyDetail(companyId);

      if (data != null) {
        companyData.value = data as Map<String, dynamic>?;
      } else {
        errorMessage.value = 'Failed to load company details';
      }
    } catch (e) {
      errorMessage.value = 'Error: $e';
      print('❌ Error fetching company detail: $e');
    } finally {
      isLoading.value = false;
    }
  }

  // Clear state when closing
  void clearData() {
    companyData.value = null;
    errorMessage.value = '';
  }

  @override
  void onClose() {
    clearData();
    super.onClose();
  }

  // Delete logic
    Future<bool> deleteCompany(String companyId) async {
      try {
        isLoading.value = true;

        final success = await ApiService.deleteResource('companies', companyId);

        if (success) {
          // Update the main list instantly
          final companyListController = Get.find<CompanyController>();
          companyListController.removeCompanyById(companyId);

          // Show success (snackbar handled outside)
          return true;
        } else {
          return false;
        }
      } catch (e) {
        Get.snackbar('Error', 'An error occurred: $e',
            snackPosition: SnackPosition.BOTTOM);
        print('❌ Delete company error: $e');
        return false;
      } finally {
        isLoading.value = false;
      }
    }

}
