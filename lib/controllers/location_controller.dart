import 'package:get/get.dart';
import 'package:mobile_sigma_app/api/api_service.dart';

class LocationController extends GetxController {
  var provinces = <dynamic>[].obs;
  var districts = <dynamic>[].obs;
  var subdistricts = <dynamic>[].obs;
  var wards = <dynamic>[].obs;
  var zipcodes = <dynamic>[].obs;

  var isLoading = false.obs;

  // ✅ Load provinces
  Future<void> loadProvinces() async {
    isLoading(true);
    final data = await ApiService.getProvinces();
    if (data != null) provinces.value = data;
    isLoading(false);
  }

  // ✅ Load districts
  Future<void> loadDistricts(String provinceId) async {
    isLoading(true);
    final data = await ApiService.getDistricts(provinceId);
    if (data != null) districts.value = data;
    isLoading(false);
  }

  // ✅ Load subdistricts
  Future<void> loadSubdistricts(String districtId) async {
    isLoading(true);
    final data = await ApiService.getSubdistricts(districtId);
    if (data != null) subdistricts.value = data;
    isLoading(false);
  }

  // ✅ Load wards
  Future<void> loadWards(String subdistrictId) async {
    isLoading(true);
    final data = await ApiService.getWards(subdistrictId);
    if (data != null) wards.value = data;
    isLoading(false);
  }

  // ✅ Load zipcodes
  Future<void> loadZipcodes(String wardId) async {
    isLoading(true);
    final data = await ApiService.getZipcodes(wardId);
    if (data != null) zipcodes.value = data;
    isLoading(false);
  }

  // ✅ Autofill from zipcode
  Future<Map<String, dynamic>?> autofillFromZip(String zip) async {
    return await ApiService.getLocationFromZipcode(zip);
  }

  // ✅ Optional: clear when user changes higher level dropdown
  void clearBelow(String level) {
    if (level == 'province') {
      districts.clear();
      subdistricts.clear();
      wards.clear();
      zipcodes.clear();
    } else if (level == 'district') {
      subdistricts.clear();
      wards.clear();
      zipcodes.clear();
    } else if (level == 'subdistrict') {
      wards.clear();
      zipcodes.clear();
    } else if (level == 'ward') {
      zipcodes.clear();
    }
  }
}
