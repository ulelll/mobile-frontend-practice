import 'package:get/get.dart';
import 'package:mobile_sigma_app/api/api_service.dart';

class ProductController extends GetxController {
  var products = [].obs;
  var isLoading = false.obs;

    // Categories
  var categories = <dynamic>[].obs;                  // dropdown
  var categoryDetail = <String, dynamic>{}.obs;  //prefill

//list
  Future<void> fetchProducts() async {
    isLoading.value = true;
    final data = await ApiService.getProducts();
    if (data != null) {
      products.value = data;
    }
    isLoading.value = false;
  }

  //remove 
    void removeProductById(String productId) {
    products.value = products.where((c) => c['id'] != productId).toList();
  } 

  //create 
   Future<bool> createProduct(Map<String, dynamic> payload) async {
    isLoading.value = true;
    final success = await ApiService.createResource('products', payload);
    isLoading.value = false;
    return success;
  }

  //update
    Future<bool> updateProduct(String id, Map<String, dynamic> payload) async {
    isLoading.value = true;
    final success = await ApiService.updateResource('products', id, payload);
    isLoading.value = false;
    return success;
  }

  //detail
    Future<Map<String, dynamic>?> getProductDetail(String id) async {
    isLoading.value = true;
    final data = await ApiService.getProductsDetail(id);
    isLoading.value = false;
    return data;
  }

  //category
  Future<void> loadCategories() async {
    final data = await ApiService.getProductCategories();
    if (data != null) categories.value = data;
  }

  Future<void> loadCategoryDetail(String categoryId) async {
    final data = await ApiService.getProductCategoryDetail(categoryId);
    if (data != null) categoryDetail.value = data;
  }
}
