import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../api/api_service.dart';


class LoginController extends GetxController {
  var isLoading = false.obs;

  Future<void> login(String username, String password) async {
    isLoading.value = true;

    final response = await ApiService.login(username, password);
    isLoading.value = false;

    if (response != null && response['session'] != null) {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('access_token', response['session']['access_token']);
      await prefs.setString('refresh_token', response['session']['refresh_token']);
      await prefs.setString('username', response['user']['username']);
      await prefs.setString('fullname', response['user']['full_name']);

      print('✅ Login success! Token saved.');

      // Navigate ke dashboard
      Get.offAllNamed('/dashboard');
    } else {
      Get.snackbar('Login Failed', 'Invalid username or password');
    }
  }
}
