import 'dart:io';

import 'package:get/get.dart';
import 'package:mobile_sigma_app/api/api_service.dart';
import 'package:http/http.dart' as http;

class CategoryController extends GetxController {
  var companyCategories = <dynamic>[].obs;
  var productCategories = <dynamic>[].obs;

  Future<void> fetchCompanyCategories() async {
    companyCategories.value = [
      {
        "id": "fd812a43-4dba-466c-b0cc-ee0043271ce8",
        "code_id": "11001",
        "name": "B2B",
        "note": "Business to Business",
        "created_at": "2025-10-14T03:19:24.543975+00:00",
        "updated_at": "2025-10-14T03:19:24.543975+00:00"
      },
      {
        "id": "823385a7-d2bc-4b2c-b3b7-f7527a696dc7",
        "code_id": "11002",
        "name": "B2C",
        "note": "Business to Consumer",
        "created_at": "2025-10-14T03:19:24.543975+00:00",
        "updated_at": "2025-10-14T03:19:24.543975+00:00"
      },
      {
        "id": "974162be-d054-4f90-bee1-8d26a1463f28",
        "code_id": "11003",
        "name": "B2D",
        "note": "Business to Distributor",
        "created_at": "2025-10-14T03:19:24.543975+00:00",
        "updated_at": "2025-10-14T03:19:24.543975+00:00"
      },
      {
        "id": "439800c7-c792-482d-84b4-1ccedf3d9150",
        "code_id": "11004",
        "name": "B2G",
        "note": "Business to Government",
        "created_at": "2025-10-14T03:19:24.543975+00:00",
        "updated_at": "2025-10-14T03:19:24.543975+00:00"
      },
      {
        "id": "eb77d97a-3e6a-4f39-a39d-caae0f94cbec",
        "code_id": "11005",
        "name": "OEM",
        "note": "Original Equipment Manufacturer",
        "created_at": "2025-10-14T03:19:24.543975+00:00",
        "updated_at": "2025-10-14T03:19:24.543975+00:00"
      }
    ];
  }

  Future<void> fetchProductCategories() async {
    productCategories.value = [
      {
      "id": "fe1d84e6-2f25-48c3-8717-f83c17db9bd4",
      "code_id": "13001",
      "name": "Printers",
      "note": "Printing devices and accessories",
      "created_at": "2025-10-14T03:19:24.543975+00:00",
      "updated_at": "2025-10-14T03:19:24.543975+00:00"
    },
    {
      "id": "917730c5-c824-4e89-a381-70db4d19c550",
      "code_id": "13002",
      "name": "Hardware",
      "note": "Computers and components",
      "created_at": "2025-10-14T03:19:24.543975+00:00",
      "updated_at": "2025-10-14T03:19:24.543975+00:00"
    },
    {
      "id": "fb7e3b68-d5f2-4b2a-856b-b1dd0476ba7f",
      "code_id": "13003",
      "name": "Consumables",
      "note": "Inks, toners, papers",
      "created_at": "2025-10-14T03:19:24.543975+00:00",
      "updated_at": "2025-10-14T03:19:24.543975+00:00"
    },
    {
      "id": "66e956cc-03c9-4736-9dba-e0305c887b9a",
      "code_id": "13004",
      "name": "Machinery",
      "note": "Large format and cutting machines",
      "created_at": "2025-10-14T03:19:24.543975+00:00",
      "updated_at": "2025-10-14T03:19:24.543975+00:00"
    },
    {
      "id": "4ab80a27-b13b-43e8-bccc-4df397b26501",
      "code_id": "13005",
      "name": "Signage",
      "note": "Display and signboard products",
      "created_at": "2025-10-14T03:19:24.543975+00:00",
      "updated_at": "2025-10-14T03:19:24.543975+00:00"
    }
    ];

  }
}
