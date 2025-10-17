import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mobile_sigma_app/controllers/address_controller.dart';
import 'custom_dropdown.dart';

class AddressDropdowns extends StatelessWidget {
  final AddressController controller;
  final RxString selectedProvince;
  final RxString selectedDistrict;
  final RxString selectedSubdistrict;
  final RxString selectedWard;

  const AddressDropdowns({
    super.key,
    required this.controller,
    required this.selectedProvince,
    required this.selectedDistrict,
    required this.selectedSubdistrict,
    required this.selectedWard,
  });

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      // 🧠 kalau provinsi belum ke-load, tampilkan loader
      if (controller.provinces.isEmpty) {
        return const Center(child: CircularProgressIndicator());
      }

      return Column(
        children: [
          CustomDropdown(
            label: "Province",
            items: controller.provinces,
            selectedValue: selectedProvince.value.isEmpty
                ? null
                : selectedProvince.value,
            onChanged: (val) {
              selectedProvince.value = val ?? '';
              selectedDistrict.value = '';
              selectedSubdistrict.value = '';
              selectedWard.value = '';
              if (val != null && val.isNotEmpty) {
                controller.fetchDistricts(val);
              }
            },
            itemLabelBuilder: (item) => item['name'],
            required: true,
          ),
          if (controller.districts.isNotEmpty)
            CustomDropdown(
              label: "District",
              items: controller.districts,
              selectedValue: selectedDistrict.value.isEmpty
                  ? null
                  : selectedDistrict.value,
              onChanged: (val) {
                selectedDistrict.value = val ?? '';
                selectedSubdistrict.value = '';
                selectedWard.value = '';
                if (val != null && val.isNotEmpty) {
                  controller.fetchSubdistricts(val);
                }
              },
              itemLabelBuilder: (item) => item['name'],
            ),
          if (controller.subdistricts.isNotEmpty)
            CustomDropdown(
              label: "Subdistrict",
              items: controller.subdistricts,
              selectedValue: selectedSubdistrict.value.isEmpty
                  ? null
                  : selectedSubdistrict.value,
              onChanged: (val) {
                selectedSubdistrict.value = val ?? '';
                selectedWard.value = '';
                if (val != null && val.isNotEmpty) {
                  controller.fetchWards(val);
                }
              },
              itemLabelBuilder: (item) => item['name'],
            ),
          if (controller.wards.isNotEmpty)
            CustomDropdown(
              label: "Ward",
              items: controller.wards,
              selectedValue:
                  selectedWard.value.isEmpty ? null : selectedWard.value,
              onChanged: (val) {
                selectedWard.value = val ?? '';
                if (val != null && val.isNotEmpty) {
                  controller.fetchZipcodes(val);
                }
              },
              itemLabelBuilder: (item) => item['name'],
            ),
        ],
      );
    });
  }
}
