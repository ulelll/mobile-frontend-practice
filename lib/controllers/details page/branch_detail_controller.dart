import 'package:get/get.dart';
import 'package:mobile_sigma_app/api/api_service.dart';
import 'package:mobile_sigma_app/controllers/branch_controller.dart';

class BranchDetailController extends GetxController {
  var branchData = Rxn<Map<String, dynamic>>();
  var isLoading = false.obs;
  var isDeleting = false.obs;
  var errorMessage = ''.obs;


  Future<void> fetchBranchDetail(String branchId) async {
    try {
      isLoading.value = true;
      errorMessage.value = '';

      final data = await ApiService.getBranchesDetail(branchId);
        if (data != null) {
          branchData.value = data;
        } else {
          errorMessage.value = 'Failed to load branch details';
        }
        } catch (e) {
          errorMessage.value = 'Error: $e';
          print('❌ Error fetching branch detail: $e');
        } finally {
          isLoading.value = false;
        }
  }

  void clearData() {
    branchData.value = null;
    errorMessage.value = '';
  }

  @override
  void onClose() {
    clearData();
    super.onClose();
  }

  
  Future<bool> deleteBranch(String branchId) async {
      try {
        isLoading.value = true;

        final success = await ApiService.deleteResource('branches', branchId);

        if (success) {
          // Update the main list instantly
          final branchListController = Get.find<BranchController>();
          branchListController.removeBranchById(branchId);

          // Show success (snackbar handled outside)
          return true;
        } else {
          return false;
        }
      } catch (e) {
        Get.snackbar('Error', 'An error occurred: $e',
            snackPosition: SnackPosition.TOP);
        print('❌ Delete branch error: $e');
        return false;
      } finally {
        isLoading.value = false;
      }
    }
}