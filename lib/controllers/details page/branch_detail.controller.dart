import 'package:get/get.dart';
import 'package:mobile_sigma_app/api/api_service.dart';

class BranchDetailController extends GetxController {
  var branchData = Rxn<Map<String, dynamic>>();
  var isLoading = false.obs;
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
}