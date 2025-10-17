import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:mobile_sigma_app/utils/storage_service.dart';
import 'package:get/get.dart';

class ApiService {
  static const baseUrl = 'https://sigma-app-api-prod.up.railway.app/api';

  /// 🔧 Generic request handler with auto-refresh support
  static Future<dynamic> _sendRequest(
    String method,
    String endpoint, {
    Map<String, dynamic>? body,
    bool noRetry = false,
  }) async {
    final token = await StorageService.getAccessToken();
    if (token == null) {
      print('⚠️ No access token found.');
      if (Get.currentRoute != "/login") {
        Get.offAllNamed("/login");
        Get.snackbar("Error", "Silahkan login kembali");
      }
      return null;
    }

    final url = Uri.parse('$baseUrl/$endpoint');
    final headers = {
      'Authorization': 'Bearer $token',
      'Content-Type': 'application/json',
    };

    print("Url request: $url");
    print("Body request: ${jsonEncode(body)}");

    http.Response response;
    try {
      print("For url $url header: $headers");
      switch (method.toUpperCase()) {
        case 'GET':
          response = await http.get(url, headers: headers);
          break;
        case 'POST':
          response =
              await http.post(url, headers: headers, body: jsonEncode(body));
          break;
        case 'PUT':
          response =
              await http.put(url, headers: headers, body: jsonEncode(body));
          break;
        case 'DELETE':
          response = await http.delete(url, headers: headers);
          break;
        default:
          throw Exception('❌ Unsupported HTTP method: $method');
      }

      print('📡 [$method $endpoint] STATUS: ${response.statusCode}');
      print('📦 RESPONSE: ${response.body}');

      if (response.statusCode >= 200 && response.statusCode < 300) {
        if (response.body.isNotEmpty) return jsonDecode(response.body);
        return true;
      }

      // handle expired token
      if (response.statusCode == 401 && !noRetry) {
        print('🔁 Token expired. Refreshing...');
        final refreshed = await StorageService.refreshTokenFlow();
        if (refreshed != null) {
          return await _sendRequest(
            method,
            endpoint,
            body: body,
            noRetry: true,
          );
        } else {
          print('❌ Token refresh failed.');
          if (Get.currentRoute != "/login") {
            Get.offAllNamed("/login");
            Get.snackbar("Error", "Silahkan login kembali");
          }
          return null;
        }
      }

      print('❌ Request failed: ${response.body}');
      return null;
    } catch (e) {
      print('💥 Request error [$endpoint]: $e');
      return null;
    }
  }

  /// Simplified GET helper
  static Future<dynamic> _getRequest(String endpoint) =>
      _sendRequest('GET', endpoint);

  ///  POST / PUT / DELETE helper
  static Future<dynamic> _postRequest(
          String endpoint, Map<String, dynamic> body) =>
      _sendRequest('POST', endpoint, body: body);

  static Future<dynamic> _putRequest(
          String endpoint, Map<String, dynamic> body) =>
      _sendRequest('PUT', endpoint, body: body);

  static Future<dynamic> _deleteRequest(String endpoint) =>
      _sendRequest('DELETE', endpoint);

//AUTH
  static Future<Map<String, dynamic>?> login(
      String username, String password) async {
    final url = Uri.parse('$baseUrl/auth/login');
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({"user": username, "password": password}),
    );

    print("🟢 LOGIN STATUS: ${response.statusCode}");
    print("📦 RESPONSE: ${response.body}");

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      print('❌ Login failed: ${response.body}');
      return null;
    }
  }

  static Future<Map<String, dynamic>?> refreshToken(String refreshToken) async {
    final url = Uri.parse('$baseUrl/auth/refresh');
    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $refreshToken',
      },
      body: jsonEncode({"refresh_token": refreshToken}),
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      print('❌ Refresh token failed: ${response.body}');
      return null;
    }
  }

//user profile
  static Future<Map<String, dynamic>?> getUserProfile() async =>
      await _getRequest('auth/me');

  static Future<Map<String, dynamic>?> getUser(
          {bool noRefresh = false}) async =>
      await _getRequest('auth/me');

//COMPANY
  static Future<List<dynamic>?> getCompanies() async =>
      (await _getRequest('companies/'))?['items'];

  static Future<Map<String, dynamic>?> getCompanyDetail(String id) async =>
      await _getRequest('companies/$id');

//branch
  static Future<List<dynamic>?> getBranches() async =>
      (await _getRequest('branches/'))?['items'];

  static Future<Map<String, dynamic>?> getBranchesDetail(String id) async =>
      await _getRequest('branches/$id');

//warehouse
  static Future<List<dynamic>?> getWarehouses() async =>
      (await _getRequest('warehouses/'))?['items'];

  static Future<Map<String, dynamic>?> getWarehousesDetail(String id) async =>
      await _getRequest('warehouses/$id');
//products
  static Future<List<dynamic>?> getProducts() async =>
      (await _getRequest('products/'))?['items'];

  static Future<Map<String, dynamic>?> getProductsDetail(String id) async =>
      await _getRequest('products/$id');

//users
  static Future<List<dynamic>?> getUsers() async =>
      (await _getRequest('users/'))?['items'];

  static Future<Map<String, dynamic>?> getUserDetail(String id) async =>
      await _getRequest('users/$id');


//crud
  static Future<bool> createResource(
          String endpoint, Map<String, dynamic> payload) async =>
      await _postRequest(endpoint, payload) != null;

  static Future<bool> updateResource(
          String endpoint, String id, Map<String, dynamic> payload) async =>
      await _putRequest('$endpoint/$id', payload) != null;

  static Future<bool> deleteResource(String endpoint, String id) async =>
      await _deleteRequest('$endpoint/$id') != null;

//LOC HELPER

  static Future<List<dynamic>?> getProvinces() async =>
      await _getRequest('master/loc/provinces');

  static Future<List<dynamic>?> getDistricts(String provinceId) async =>
      await _getRequest('master/loc/provinces/$provinceId/districts');

  static Future<List<dynamic>?> getSubdistricts(String districtId) async =>
      await _getRequest('master/loc/districts/$districtId/subdistricts');

  static Future<List<dynamic>?> getWards(String subdistrictId) async =>
      await _getRequest('master/loc/subdistricts/$subdistrictId/wards');

  static Future<List<dynamic>?> getZipcodes(String wardId) async =>
      await _getRequest('master/loc/wards/$wardId/zipcodes');

  static Future<Map<String, dynamic>?> getLocationFromZipcode(
          String zip) async =>
      await _getRequest('master/loc/get_from_zipcode/$zip');



//CATEGORIES

  static Future<List<dynamic>?> getCompanyCategories() async =>
      await _getRequest('categories/company');

  static Future<Map<String, dynamic>?> getCompanyCategoryDetail(
          String categoryId) async =>
      await _getRequest('categories/company/$categoryId');

  static Future<List<dynamic>?> getProductCategories() async =>
      await _getRequest('categories/product');

  static Future<Map<String, dynamic>?> getProductCategoryDetail(
          String categoryId) async =>
      await _getRequest('categories/product/$categoryId');
}
