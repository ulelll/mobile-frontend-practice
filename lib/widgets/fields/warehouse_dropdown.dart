import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mobile_sigma_app/controllers/warehouse_controller.dart';

class WarehouseDropdown extends StatelessWidget {
  final RxString selectedWarehouseId;
  final WarehouseController controller;
  final bool required;

  const WarehouseDropdown({
    Key? key,
    required this.selectedWarehouseId,
    required this.controller,
    this.required = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (controller.isLoading.value && controller.warehouses.isEmpty) {
        return const Padding(
          padding: EdgeInsets.symmetric(vertical: 16.0),
          child: Center(child: CircularProgressIndicator()),
        );
      }

      return DropdownButtonFormField<String>(
        decoration: InputDecoration(
          labelText: "Warehouse ${required ? '*' : ''}",
          border: const OutlineInputBorder(),
          contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
        ),
        value: selectedWarehouseId.value.isEmpty ? null : selectedWarehouseId.value,
        items: controller.warehouses.map((warehouse) {
          return DropdownMenuItem<String>(
            value: warehouse['id'].toString(), 
            child: Text(warehouse['name'] ?? 'Unknown'),
          );
        }).toList(),
        onChanged: (value) {
          if (value != null) {
            selectedWarehouseId.value = value;
          }
        },
        validator: required
            ? (value) {
                if (value == null || value.isEmpty) {
                  return 'Please select a warehouse';
                }
                return null;
              }
            : null,
      );
    });
  }
}