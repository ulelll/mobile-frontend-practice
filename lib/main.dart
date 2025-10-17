import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'routes/routes.dart';
import 'pages/splash_screen.dart';

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
      initialRoute: Routes.splash,
      getPages: Routes.pages,
    );
  }
}
