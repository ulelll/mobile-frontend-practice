import 'package:get/get.dart';
import 'package:mobile_sigma_app/api/api_service.dart';

class WarehouseController extends GetxController {
  var warehouses = [].obs;
  var isLoading = false.obs;

  Future<void> fetchWarehouses() async {
    isLoading.value = true;
    final data = await ApiService.getProducts();
    if (data != null) {
      warehouses.value = data;
    }
    isLoading.value = false;
  }
}
