import 'package:get/get.dart';
import 'package:mobile_sigma_app/api/api_service.dart';

class BranchController extends GetxController {
  var branches = [].obs;
  var isLoading = false.obs;

  Future<void> fetchBranches() async {
    isLoading.value = true;
    final data = await ApiService.getBranches();
    if (data != null) {
      branches.value = data;
    }
    isLoading.value = false;
  }
}
