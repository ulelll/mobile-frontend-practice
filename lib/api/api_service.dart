import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:mobile_sigma_app/utils/storage_service.dart';

class ApiService {
  static const baseUrl = 'https://sigma-app-api-prod.up.railway.app/api';


//method / function to handle GET requests with token refresh
  static Future<dynamic> _getRequest(String endpoint, {bool noRetry = false}) async {
    final token = await StorageService.getAccessToken();
    if (token == null) {
      print('⚠️ No access token found.');
      return null;
    }

    final url = Uri.parse('$baseUrl/$endpoint');
    final response = await http.get(
      url,
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );

    print('📡 [$endpoint] STATUS CODE: ${response.statusCode}');
    print('📦 [$endpoint] RESPONSE: ${response.body}');

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else if (response.statusCode == 401 && !noRetry) {
      print('🔁 Token expired, trying refresh...');
      final newTokens = await StorageService.refreshTokenFlow();
      if (newTokens != null) {
        return await _getRequest(endpoint, noRetry: true); // retry once
      }
      return null;
    } else {
      print('❌ Request failed ($endpoint): ${response.body}');
      return null;
    }
  }



static Future<Map<String, dynamic>?> getUserProfile() async {
  final token = await StorageService.getAccessToken();
  if (token == null) {
    print('⚠️ No access token found.');
    return null;
  }

  final url = Uri.parse('$baseUrl/auth/me');
  final response = await http.get(
    url,
    headers: {
      'Authorization': 'Bearer $token',
      'Content-Type': 'application/json',
    },
  );

  print('📡 [getUserProfile] STATUS CODE: ${response.statusCode}');
  print('📦 [getUserProfile] RESPONSE: ${response.body}');

  if (response.statusCode == 200) {
    return jsonDecode(response.body) as Map<String, dynamic>;
  } else if (response.statusCode == 401) {
    print('🔁 Token expired, trying refresh...');
    final newTokens = await StorageService.refreshTokenFlow();
    if (newTokens != null) {
      return await getUserProfile(); // retry
    }
    return null;
  } else {
    print('❌ Failed to fetch user profile: ${response.body}');
    return null;
  }
}

//login
  static Future<Map<String, dynamic>?> login(String username, String password) async {
    final url = Uri.parse('$baseUrl/auth/login');
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({"user": username, "password": password}),
    );

    print("🟢 STATUS CODE: ${response.statusCode}");
    print("🟢 RESPONSE BODY: ${response.body}");

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      print('❌ Login failed: ${response.body}');
      return null;
    }
  }

//refresh token
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


//auth me atau user detail
  static Future<Map<String, dynamic>?> getUser({bool noRefresh = false}) async {
    final token = await StorageService.getAccessToken();
    if (token == null) {
      print('⚠️ No access token found.');
      return null;
    }

    final url = Uri.parse('$baseUrl/auth/me');
    final response = await http.get(
      url,
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else if (response.statusCode == 401 && !noRefresh) {
      print('🔁 Token expired, trying refresh...');
      final newTokens = await StorageService.refreshTokenFlow();
      if (newTokens != null) {
        return await getUser(noRefresh: true);
      }
      return null;
    } else {
      print('❌ Failed to fetch user: ${response.body}');
      return null;
    }
  }



//detail company
  static Future<Map<String, dynamic>?> getCompanyDetail(String companyId) async {
  final token = await StorageService.getAccessToken();
  if (token == null) {
    print('⚠️ No access token found.');
    return null;
  }

  final url = Uri.parse('$baseUrl/companies/$companyId');
  final response = await http.get(
    url,
    headers: {
      'Authorization': 'Bearer $token',
      'Content-Type': 'application/json',
    },
  );

  print('📡 [getCompanyDetail] STATUS CODE: ${response.statusCode}');
  print('📦 [getCompanyDetail] RESPONSE: ${response.body}');

  if (response.statusCode == 200) {
    return jsonDecode(response.body) as Map<String, dynamic>;
  } else if (response.statusCode == 401) {
    print('🔁 Token expired, trying refresh...');
    final newTokens = await StorageService.refreshTokenFlow();
    if (newTokens != null) {
      return await getCompanyDetail(companyId); // retry
    }
    return null;
  } else {
    print('❌ Failed to fetch company detail: ${response.body}');
    return null;
  }
}


//branch detail 
static Future<Map<String, dynamic>?> getBranchesDetail(String branchId) async {
  final token = await StorageService.getAccessToken();
  if (token == null) {
    print('⚠️ No access token found.');
    return null;
  }

  final url = Uri.parse('$baseUrl/branches/$branchId');
  final response = await http.get(
    url,
    headers: {
      'Authorization': 'Bearer $token',
      'Content-Type': 'application/json',
    },
  );

  print('📡 [getBranchesDetail] STATUS CODE: ${response.statusCode}');
  print('📦 [getBranchesDetail] RESPONSE: ${response.body}');

  if (response.statusCode == 200) {
    return jsonDecode(response.body) as Map<String, dynamic>;
  } else if (response.statusCode == 401) {
    print('🔁 Token expired, trying refresh...');
    final newTokens = await StorageService.refreshTokenFlow();
    if (newTokens != null) {
      return await getBranchesDetail(branchId); // retry
    }
    return null;
  } else {
    print('❌ Failed to fetch branch detail: ${response.body}');
    return null;
  }
}
  
  //list company, branch, product, warehouse, user
  static Future<List<dynamic>?> getCompanies() async =>
    await _getRequest('companies/') as List<dynamic>?;
  static Future<List<dynamic>?> getBranches() async =>
    await _getRequest('branches/') as List<dynamic>?;
  static Future<List<dynamic>?> getProducts() async =>
      await _getRequest('products/') as List<dynamic>?;
  static Future<List<dynamic>?> getWarehouses() async =>
      await _getRequest('warehouses/') as List<dynamic>?;
  static Future<List<dynamic>?> getUsers() async =>
      await _getRequest('users/') as List<dynamic>?;      

}
