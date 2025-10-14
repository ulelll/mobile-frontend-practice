import 'package:get/get.dart';
import 'package:mobile_sigma_app/api/api_service.dart';

class UserController extends GetxController {
  var users = [].obs;
  var isLoading = false.obs;

  Future<void> fetchUsers() async {
    isLoading.value = true;
    final data = await ApiService.getUsers();
    if (data != null) {
      users.value = data;
    }
    isLoading.value = false;
  }
}
