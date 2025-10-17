import 'package:get/get.dart';
import 'package:mobile_sigma_app/api/api_service.dart';
import 'package:mobile_sigma_app/controllers/user_controller.dart';

class UserDetailController extends GetxController {
  var userData = Rxn<Map<String, dynamic>>();
  var isLoading = false.obs;
  var isDeleting = false.obs;
  var errorMessage = ''.obs;

  Future<void> fetchUserDetail(String userId) async {
    try {
      isLoading.value = true;
      errorMessage.value = '';

      final data = await ApiService.getUserDetail(userId);
      
      if (data != null) {
        userData.value = data;
      } else {
        errorMessage.value = 'Failed to load User details';
      }
    } catch (e) {
      errorMessage.value = 'Error: $e';
      print('❌ Error fetching user detail: $e');
    } finally {
      isLoading.value = false;
    }
  }

  void clearData() {
    userData.value = null;
    errorMessage.value = '';
  }

  @override
  void onClose() {
    clearData();
    super.onClose();
  }

   Future<bool> deleteUser(String userId) async {
      try {
        isLoading.value = true;

        final success = await ApiService.deleteResource('users', userId);

        if (success) {
          // Update the main list instantly
          final userListController = Get.find<UserController>();
          userListController.removeUserById(userId);

          // Show success (snackbar handled outside)
          return true;
        } else {
          return false;
        }
      } catch (e) {
        Get.snackbar('Error', 'An error occurred: $e',
            snackPosition: SnackPosition.BOTTOM);
        print('❌ Delete user error: $e');
        return false;
      } finally {
        isLoading.value = false;
      }
    }
}