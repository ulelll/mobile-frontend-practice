import 'package:get/get.dart';
import 'package:mobile_sigma_app/api/api_service.dart';

class ProductController extends GetxController {
  var products = [].obs;
  var isLoading = false.obs;

  Future<void> fetchProducts() async {
    isLoading.value = true;
    final data = await ApiService.getProducts();
    if (data != null) {
      products.value = data;
    }
    isLoading.value = false;
  }
}
