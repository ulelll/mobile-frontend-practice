import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mobile_sigma_app/pages/splash_screen.dart';
import 'package:mobile_sigma_app/pages/login_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Sigma App',
      debugShowCheckedModeBanner: false,
      initialRoute: '/',
      getPages: [
        GetPage(name: '/', page: () => const SplashScreen()),
        GetPage(name: '/login', page: () => const LoginPage()),
      ],
    );
  }
}
