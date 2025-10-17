import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mobile_sigma_app/controllers/branch_controller.dart';

class BranchDropdown extends StatelessWidget {
  final RxString selectedBranchId;
  final BranchController controller;
  final bool required;

  const BranchDropdown({
    Key? key,
    required this.selectedBranchId,
    required this.controller,
    this.required = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (controller.isLoading.value && controller.branches.isEmpty) {
        return const Padding(
          padding: EdgeInsets.symmetric(vertical: 16.0),
          child: Center(child: CircularProgressIndicator()),
        );
      }

      return DropdownButtonFormField<String>(
        decoration: InputDecoration(
          labelText: "Branch ${required ? '*' : ''}",
          border: const OutlineInputBorder(),
          contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
        ),
        value: selectedBranchId.value.isEmpty ? null : selectedBranchId.value,
        items: controller.branches.map((branch) {
          return DropdownMenuItem<String>(
            value: branch['id'].toString(), 
            child: Text(branch['name'] ?? 'Unknown'),
          );
        }).toList(),
        onChanged: (value) {
          if (value != null) {
            selectedBranchId.value = value;
          }
        },
        validator: required
            ? (value) {
                if (value == null || value.isEmpty) {
                  return 'Please select a branch';
                }
                return null;
              }
            : null,
      );
    });
  }
}