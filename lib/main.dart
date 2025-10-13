import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mobile_sigma_app/pages/dashboard.dart';
import 'package:mobile_sigma_app/pages/product_page.dart'; 
import 'package:mobile_sigma_app/pages/splash_screen.dart';
import 'package:mobile_sigma_app/pages/login_page.dart';
import 'package:mobile_sigma_app/pages/company_page.dart';
import 'package:mobile_sigma_app/pages/branch_page.dart';
import 'package:mobile_sigma_app/pages/warehouse_page.dart';
import 'package:mobile_sigma_app/pages/user_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Sigma App',
      theme: ThemeData(
        primarySwatch: Colors.red,
      ),
      initialRoute: '/',
      getPages: [
        GetPage(name: '/', page: () => SplashScreen()),
        GetPage(name: '/login', page: () => const LoginPage()),
        GetPage(name: '/dashboard', page: () => const DashboardPage()),
        GetPage(name: '/company', page: () => const CompanyPage()),
        GetPage(name: '/branch', page: () => const BranchPage()),
        GetPage(name: '/product', page: () => const ProductPage()),
        GetPage(name: '/warehouse', page: () => const WarehousePage()),
        GetPage(name: '/user', page: () => const UserPage()),
      ],
    );
  }
}
