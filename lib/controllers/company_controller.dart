import 'package:get/get.dart';
import 'package:mobile_sigma_app/api/api_service.dart';

class CompanyController extends GetxController {
  var companies = [].obs;
  var isLoading = false.obs;

  Future<void> fetchCompanies() async {
    isLoading.value = true;
    final data = await ApiService.getCompanies();
    if (data != null) {
      companies.value = data;
    }
    isLoading.value = false;
  }
}
