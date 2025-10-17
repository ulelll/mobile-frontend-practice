import 'package:get/get.dart';
import 'package:mobile_sigma_app/api/api_service.dart';

class UserController extends GetxController {
  var users = [].obs;
  var userDetail = <String, dynamic>{}.obs;
  var isLoading = false.obs;


//list
  Future<void> fetchUsers() async {
    isLoading.value = true;
    final data = await ApiService.getUsers();
    if (data != null) {
      users.value = data;
    }
    isLoading.value = false;
  }


//get detail
Future<void> getUserDetail(String id) async {
    try {
      isLoading(true);
      final data = await ApiService.getUserDetail(id);
      if (data != null) userDetail.value = data;
    } finally {
      isLoading(false);
    }
  }
  
//create
   Future<bool> createUser(Map<String, dynamic> payload) async {
    try {
      isLoading(true);
      final success = await ApiService.createResource('users/', payload);
      return success;
    } finally {
      isLoading(false);
    }
  }

  // ✅ Update
  Future<bool> updateUser(String id, Map<String, dynamic> payload) async {
    try {
      isLoading(true);
      final success = await ApiService.updateResource('users', id, payload);
      return success;
    } finally {
      isLoading(false);
    }
  }

  // ✅ Delete (optional)
  Future<bool> deleteUser(String id) async {
    try {
      isLoading(true);
      final success = await ApiService.deleteResource('users', id);
      if (success) {
        users.removeWhere((c) => c['id'] == id);
      }
      return success;
    } finally {
      isLoading(false);
    }
  }

  //remove
  void removeUserById(String userId) {
    users.value = users.where((c) => c['id'] != userId).toList();
  }
}
