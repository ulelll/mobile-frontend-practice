import 'package:get/get.dart';
import 'package:mobile_sigma_app/api/api_service.dart';
import 'package:mobile_sigma_app/controllers/product_controller.dart';

class ProductDetailController extends GetxController {
  var productData = Rxn<Map<String, dynamic>>();
  var isLoading = false.obs;
  var isDeleting = false.obs;
  var errorMessage = ''.obs;


  Future<void> fetchProductDetail(String productId) async {
    try {
      isLoading.value = true;
      errorMessage.value = '';

      final data = await ApiService.getProductsDetail(productId); 
      if (data != null) {
        productData.value = data;
      } else {
        errorMessage.value = 'Failed to load product details';
      }
    } catch (e) {
      errorMessage.value = 'Error: $e';
      print('❌ Error fetching product detail: $e');
    } finally {
      isLoading.value = false;
    }
  }

  void clearData() {
    productData.value = null;
    errorMessage.value = '';
  }

  @override
  void onClose() {
    clearData();
    super.onClose();
  }

  
  Future<bool> deleteProduct(String productId) async {
      try {
        isLoading.value = true;

        final success = await ApiService.deleteResource('products', productId);

        if (success) {
          // Update the main list instantly
          final productListController = Get.find<ProductController>();
          productListController.removeProductById(productId);

          return true;  
        } else {
          return false;
        }
      } catch (e) {
        Get.snackbar('Error', 'An error occurred: $e',
            snackPosition: SnackPosition.TOP);
        print('❌ Delete product error: $e');
        return false;
      } finally {
        isLoading.value = false;
      }
    }
}