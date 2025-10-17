import 'package:get/get.dart';
import 'package:mobile_sigma_app/api/api_service.dart';

class WarehouseController extends GetxController {
  var warehouses = [].obs;
  var isLoading = false.obs;
  var warehouseDetail = <String, dynamic>{}.obs;

  //list
  Future<void> fetchWarehouses() async {
    isLoading.value = true;
    final data = await ApiService.getWarehouses();
    if (data != null) {
      warehouses.value = data;
    }
    isLoading.value = false;
  }

    // ✅ Get detail
  Future<void> getWarehousesDetail (String id) async {
    try {
      isLoading(true);
      final data = await ApiService.getWarehousesDetail(id);
      if (data != null) warehouseDetail.value = data;
    } finally {
      isLoading(false);
    }
  }

    //create
   Future<bool> createWarehouse(Map<String, dynamic> payload) async {
    try {
      isLoading(true);
      final success = await ApiService.createResource('warehouses/', payload);
      return success;
    }finally {
      isLoading(false);
    }
  }

    //edit
   Future<bool> editWarehouse(String id, Map<String, dynamic> payload) async {
    try {
      isLoading(true);
      final success = await ApiService.updateResource('warehouses/', id, payload);
      return success;
    }finally {
      isLoading(false);
    }
  }

//remove
    Future<bool> deleteWarehouse(String id) async {
    try {
      isLoading(true);
      final success = await ApiService.deleteResource('warehouses', id);
      if (success) {
        warehouses.removeWhere((c) => c['id'] == id);
      }
      return success;
    } finally {
      isLoading(false);
    }
  }
  //remove
  void removeWarehouseById(String warehouseId) {
    warehouses.value = warehouses.where((c) => c['id'] != warehouseId).toList();
  }
}