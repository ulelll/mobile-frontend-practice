import 'package:get/get.dart';
import 'package:mobile_sigma_app/pages/forms-create/create_warehouse.dart';
import 'package:mobile_sigma_app/pages/list_pages/company_page.dart';
import 'package:mobile_sigma_app/pages/forms-create/create_company.dart';
import 'package:mobile_sigma_app/pages/forms-create/create_user.dart';
import 'package:mobile_sigma_app/pages/forms-edit/edit_company.dart';
import 'package:mobile_sigma_app/pages/forms-edit/edit_user.dart';
import 'package:mobile_sigma_app/pages/details%20page/company_detail_page.dart';
import 'package:mobile_sigma_app/pages/splash_screen.dart';
import 'package:mobile_sigma_app/pages/login_page.dart';
import 'package:mobile_sigma_app/pages/dashboard.dart';
import 'package:mobile_sigma_app/pages/list_pages/product_page.dart';
import 'package:mobile_sigma_app/pages/details%20page/product_detail_page.dart';
import 'package:mobile_sigma_app/pages/list_pages/branch_page.dart';
import 'package:mobile_sigma_app/pages/details%20page/branch_detail_page.dart';
import 'package:mobile_sigma_app/pages/list_pages/warehouse_page.dart';
import 'package:mobile_sigma_app/pages/details%20page/warehouse_detail_page.dart';
import 'package:mobile_sigma_app/pages/list_pages/user_page.dart';
import 'package:mobile_sigma_app/pages/details%20page/user_detail_page.dart';
import 'package:mobile_sigma_app/pages/profile_page.dart';


class Routes {
  // Route names
  static const splash = '/';
  static const login = '/login';
  static const dashboard = '/dashboard';

  // Company
  static const companyList = '/company';
  static const companyCreate = '/company/create';
  static const companyEdit = '/company/edit/:companyId';
  static const companyDetail = '/company/detail/:companyId';

  // Product
  static const productList = '/product';
  static const productCreate = '/product/create';
  static const productEdit = '/product/edit/:productId';
  static const productDetail = '/product/detail/:productId';

  // Branch
  static const branchList = '/branch';
  static const branchCreate = '/branch/create';
  static const branchEdit = '/branch/edit/:branchId';
  static const branchDetail = '/branch/detail/:branchId';

  // Warehouse
  static const warehouseList = '/warehouse';
  static const warehouseCreate = '/warehouse/create';
  static const warehouseEdit = '/warehouse/edit/:warehouseId';
  static const warehouseDetail = '/warehouse/detail/:warehouseId';

  // User
  static const userList = '/user';
  static const userCreate = '/user/create';
  static const userEdit = '/user/edit/:userId';
  static const userDetail = '/user/detail/:userId';

  static const userProfile ='/profile';

  // GetPages
  static final pages = [
    GetPage(name: splash, page: () => SplashScreen()),
    GetPage(name: login, page: () => const LoginPage()),
    GetPage(name: dashboard, page: () => const DashboardPage()),

  //profile
    GetPage(name: userProfile, page: () => ProfilePage ()),
   // Company
    GetPage(name: companyList, page: () => const CompanyPage()), 
    GetPage(name: companyCreate, page: () => const CreateCompanyPage()), ///dont firget this one
    GetPage(
      name: companyEdit,
      page: () {
        final companyId = Get.parameters['companyId']!;
        return EditCompanyPage(companyId: companyId);
      },
    ),
    GetPage(
      name: companyDetail,
      page: () {
        final companyId = Get.parameters['companyId']!;
        return CompanyDetailPage(companyId: companyId);
      },
    ),


    // Product
    GetPage(name: productList, page: () => const ProductPage()),
    GetPage(
      name: productDetail,
      page: () {
        final productId = Get.parameters['productId']!;
        return ProductDetailPage(productId: productId);
      },
    ),

    // Branch
    GetPage(name: branchList, page: () => const BranchPage()),
    GetPage(
      name: branchDetail,
      page: () {
        final branchId = Get.parameters['branchId']!;
        return BranchDetailPage(branchId: branchId);
      },
    ),

    // Warehouse
    GetPage(name: warehouseList, page: () => const WarehousePage()),
    GetPage(name: warehouseCreate, page: () => const CreateWarehousePage()),
    GetPage(
      name: warehouseDetail,
      page: () {
        final warehouseId = Get.parameters['warehouseId']!;
        return WarehouseDetailPage(warehouseId: warehouseId);
      },
    ),

    // User
    GetPage(name: userList, page: () => const UserPage()),
    GetPage(name: userCreate, page: () => const CreateUserPage()),
    GetPage(
      name: '/user/edit/:userId',
      page: () {
        final userId = Get.parameters['userId']!;
        return EditUserPage(userId: userId);
      },
    ),
    GetPage(
      name: userDetail,
      page: () {
        final userId = Get.parameters['userId']!;
        return UserDetailPage(userId: userId);
      },
    ),
  ];

  

  // Helper functions for navigation
  static String companyDetailRoute(String companyId) => '/company/detail/$companyId';
  static String companyEditRoute(String companyId) => '/company/edit/$companyId';
  static String companyCreateRoute() => '/company/create';


//user
  static String userCreateRoute() => '/user/create';
  static String userEditRoute(String userId) => '/user/edit/$userId';

  //warehouse 
  static String warehouseCreateRoute() => '/warehouse/create';  





}

