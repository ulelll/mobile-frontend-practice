import 'package:get/get.dart';
import 'package:mobile_sigma_app/api/api_service.dart';

class CompanyDetailController extends GetxController {
  var companyData = Rxn<Map<String, dynamic>>();
  var isLoading = false.obs;
  var errorMessage = ''.obs;

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

  void clearData() {
    companyData.value = null;
    errorMessage.value = '';
  }

  @override
  void onClose() {
    clearData();
    super.onClose();
  }
}