import 'package:get/get.dart';
import 'package:mobile_sigma_app/api/api_service.dart';

class UserProfileController extends GetxController {
  var user = Rx<Map<String, dynamic>?>(null);
  var isLoading = false.obs;
  var error = Rx<String?>(null);

  @override
  void onInit() {
    super.onInit();
    fetchUserProfile();
  }

  Future<void> fetchUserProfile() async {
    isLoading.value = true;
    error.value = null;
    try {
      final data = await ApiService.getUser();
      if (data != null) {
        user.value = data;
      } else {
        error.value = 'Failed to load profile';
      }
    } catch (e) {
      error.value = e.toString();
    } finally {
      isLoading.value = false;
    }
  }
}