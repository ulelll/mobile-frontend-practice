import 'package:get/get.dart';
import 'package:mobile_sigma_app/api/api_service.dart';
import 'package:mobile_sigma_app/controllers/warehouse_controller.dart';

class WarehouseDetailController extends GetxController {
  var warehouseData = Rxn<Map<String, dynamic>>();
  var isLoading = false.obs;
  var isDeleting = false.obs;
  var errorMessage = ''.obs;

  Future<void> fetchWarehouseDetail(String warehouseId) async {
    try {
      isLoading.value = true;
      errorMessage.value = '';

      final data = await ApiService.getWarehousesDetail(warehouseId);
      
      if (data != null) {
        warehouseData.value = data;
      } else {
        errorMessage.value = 'Failed to load warehouse details';
      }
    } catch (e) {
      errorMessage.value = 'Error: $e';
      print('❌ Error fetching warehouse detail: $e');
    } finally {
      isLoading.value = false;
    }
  }

  void clearData() {
    warehouseData.value = null;
    errorMessage.value = '';
  }

  @override
  void onClose() {
    clearData();
    super.onClose();
  }

   Future<bool> deleteWarehouse(String warehouseId) async {
      try {
        isLoading.value = true;

        final success = await ApiService.deleteResource('warehouses', warehouseId);

        if (success) {
          // Update the main list instantly
          final warehouseListController = Get.find<WarehouseController>();
          warehouseListController.removeWarehouseById(warehouseId);

          // Show success (snackbar handled outside)
          return true;
        } else {
          return false;
        }
      } catch (e) {
        Get.snackbar('Error', 'An error occurred: $e',
            snackPosition: SnackPosition.BOTTOM);
        print('❌ Delete warehouse error: $e');
        return false;
      } finally {
        isLoading.value = false;
      }
    }
}