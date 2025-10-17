import 'package:shared_preferences/shared_preferences.dart';
import 'package:mobile_sigma_app/api/api_service.dart';

class StorageService {
  static const _keyAccessToken = 'access_token';
  static const _keyRefreshToken = 'refresh_token';
  static const _keyExpiresAt = 'expires_at';

  // save session
  static Future<void> saveSession({
    required String accessToken,
    required String refreshToken,
    required int expiresIn,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    final expiresAt = DateTime.now().add(Duration(seconds: expiresIn)).toIso8601String();

    await prefs.setString(_keyAccessToken, accessToken);
    await prefs.setString(_keyRefreshToken, refreshToken);
    await prefs.setString(_keyExpiresAt, expiresAt);
  }

  // get access token
  static Future<String?> getAccessToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_keyAccessToken);
  }

  // get refresh token
  static Future<String?> getRefreshToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_keyRefreshToken);
  }

  // get token expiry
  static Future<DateTime?> getExpiresAt() async {
    final prefs = await SharedPreferences.getInstance();
    final str = prefs.getString(_keyExpiresAt);
    return str != null ? DateTime.parse(str) : null;
  }

  // clear session
  static Future<void> clearSession() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_keyAccessToken);
    await prefs.remove(_keyRefreshToken);
    await prefs.remove(_keyExpiresAt);
  }
  
  // load entire session
  static Future<Map<String, dynamic>?> loadSession() async {
    final prefs = await SharedPreferences.getInstance();
    final accessToken = prefs.getString(_keyAccessToken);
    final refreshToken = prefs.getString(_keyRefreshToken);
    final expiresAtStr = prefs.getString(_keyExpiresAt);

    if (accessToken != null && refreshToken != null && expiresAtStr != null) {
      return {
        'access_token': accessToken,
        'refresh_token': refreshToken,
        'expires_at': DateTime.parse(expiresAtStr),
      };
    }
    return null; // no session saved
  }

  //  refresh token flow
  static Future<Map<String, String>?> refreshTokenFlow() async {
    final refreshToken = await getRefreshToken();
    if (refreshToken == null) return null;

    final refreshed = await ApiService.refreshToken(refreshToken);
    if (refreshed != null && refreshed['session'] != null) {
      final session = refreshed['session'];
      await saveSession(
        accessToken: session['access_token'],
        refreshToken: session['refresh_token'],
        expiresIn: session['expires_in'],
      );
      return {
        'accessToken': session['access_token'],
        'refreshToken': session['refresh_token'],
      };
    }

    await clearSession();
    return null;
  }

//   static Future<void> clearTokens() async {
//   await clearSession();
// }
}
