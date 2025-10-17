import 'package:get/get.dart';
import 'package:mobile_sigma_app/api/api_service.dart';

class CompanyController extends GetxController {
  var companies = <dynamic>[].obs;
  var companyDetail = <String, dynamic>{}.obs;
  var isLoading = false.obs;

  // ✅ Get all companies
  Future<void> fetchCompanies() async {
    try {
      isLoading(true);
      final data = await ApiService.getCompanies();
      if (data != null) companies.value = data;
    } finally {
      isLoading(false);
    }
  }

  // ✅ Get detail
  Future<void> getCompanyDetail(String id) async {
    try {
      isLoading(true);
      final data = await ApiService.getCompanyDetail(id);
      if (data != null) companyDetail.value = data;
    } finally {
      isLoading(false);
    }
  }

  // ✅ Create
  Future<bool> createCompany(Map<String, dynamic> payload) async {
    try {
      isLoading(true);
      final success = await ApiService.createResource('companies/', payload);
      return success;
    } finally {
      isLoading(false);
    }
  }

  // ✅ Update
  Future<bool> updateCompany(String id, Map<String, dynamic> payload) async {
    try {
      isLoading(true);
      final success = await ApiService.updateResource('companies', id, payload);
      return success;
    } finally {
      isLoading(false);
    }
  }

  // ✅ Delete (optional)
  Future<bool> deleteCompany(String id) async {
    try {
      isLoading(true);
      final success = await ApiService.deleteResource('companies', id);
      if (success) {
        companies.removeWhere((c) => c['id'] == id);
      }
      return success;
    } finally {
      isLoading(false);
    }
  }

  // ✅ Utility to remove company locally
  void removeCompanyById(String id) {
    companies.value = companies.where((c) => c['id'] != id).toList();
  }
}
