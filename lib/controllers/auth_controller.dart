import 'package:get/get.dart';
import 'package:mobile_sigma_app/api/api_service.dart';
import 'package:mobile_sigma_app/utils/storage_service.dart';
import 'package:flutter/material.dart';

class AuthController extends GetxController {
  final isLoading = false.obs;

  Future<bool> login(String username, String password) async {
    try {
      isLoading.value = true;

      final response = await ApiService.login(username, password);

      if (response != null && response['session'] != null) {
        final session = response['session'];
        await StorageService.saveSession(
          accessToken: session['access_token'],
          refreshToken: session['refresh_token'],
          expiresIn: session['expires_in'],
        );

        isLoading.value = false;
        print("✅ Login success!");
        return true;
      } else {
        isLoading.value = false;
        print("❌ Invalid credentials");
        return false;
      }
    } catch (e) {
      isLoading.value = false;
      print("⚠️ Login error: $e");
      return false;
    }
  }

  Future<bool> checkAndRefreshToken() async {
    final session = await StorageService.loadSession();
    if (session == null) {
      print('⚠️ No session found, redirecting to login.');
      Get.offAllNamed('/login');
      return false;
    }

    final expiresAt = session['expires_at'] as DateTime;
    final refreshToken = session['refresh_token'];

    if (DateTime.now().isAfter(expiresAt)) {
      print('⚠️ Token expired, refreshing...');
      final refreshed = await ApiService.refreshToken(refreshToken);

      if (refreshed != null && refreshed['session'] != null) {
        final newSession = refreshed['session'];
        await StorageService.saveSession(
          accessToken: newSession['access_token'],
          refreshToken: newSession['refresh_token'],
          expiresIn: newSession['expires_in'],
        );
        return true;
      } else {
        await StorageService.clearSession();
        Get.offAllNamed('/login');
        return false;
      }
    } else {
      final user = await ApiService.getUser();
      if (user != null) {
        print('✅ Token valid, user fetched.');
        return true;
      } else {
        print('❌ Invalid token, clearing session.');
        await StorageService.clearSession();
        Get.offAllNamed('/login');
        return false;
      }
    }
  }
}