import 'package:get/get.dart';
import 'package:mobile_sigma_app/api/api_service.dart';

class AddressController extends GetxController {
  // lists for dropdowns
  var provinces = <dynamic>[].obs;
  var districts = <dynamic>[].obs;
  var subdistricts = <dynamic>[].obs;
  var wards = <dynamic>[].obs;
  var zipcodes = <dynamic>[].obs;

  // selected values (nullable reactive strings)
  final selectedProvince = RxnString();
  final selectedDistrict = RxnString();
  final selectedSubdistrict = RxnString();
  final selectedWard = RxnString();
  final selectedZipcode = RxnString();

  var isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();

    fetchProvinces();
  }

  Future<void> fetchProvinces() async {
    final data = await ApiService.getProvinces();
    if (data != null) provinces.assignAll(data);
  }

  Future<void> fetchDistricts(String provinceId) async {
    // clear dependent lists and selections
    districts.clear();
    subdistricts.clear();
    wards.clear();
    zipcodes.clear();
    selectedDistrict.value = null;
    selectedSubdistrict.value = null;
    selectedWard.value = null;
    selectedZipcode.value = null;

    final data = await ApiService.getDistricts(provinceId);
    if (data != null) districts.assignAll(data);
  }

  Future<void> fetchSubdistricts(String districtId) async {
    subdistricts.clear();
    wards.clear();
    zipcodes.clear();
    selectedSubdistrict.value = null;
    selectedWard.value = null;
    selectedZipcode.value = null;

    final data = await ApiService.getSubdistricts(districtId);
    if (data != null) subdistricts.assignAll(data);
  }

  Future<void> fetchWards(String subdistrictId) async {
    wards.clear();
    zipcodes.clear();
    selectedWard.value = null;
    selectedZipcode.value = null;

    final data = await ApiService.getWards(subdistrictId);
    if (data != null) wards.assignAll(data);
  }


  Future<void> fetchZipcodes(String wardId) async {
    zipcodes.clear();
    selectedZipcode.value = null;

    final data = await ApiService.getZipcodes(wardId);
    if (data != null) zipcodes.assignAll(data);
  }

  // Optional helper: autofill everything from a zipcode string
  Future<void> autofillFromZipAndPopulate(String zip) async {
    final loc = await ApiService.getLocationFromZipcode(zip);
    if (loc == null) return;

    // expect loc contains province_id, district_id, subdistrict_id, ward_id
    final provId = loc['province_id']?.toString();
    final distId = loc['district_id']?.toString();
    final subdId = loc['subdistrict_id']?.toString();
    final wardId = loc['ward_id']?.toString();

    if (provId != null) {
      selectedProvince.value = provId;
      await fetchDistricts(provId);
    }
    if (distId != null) {
      selectedDistrict.value = distId;
      await fetchSubdistricts(distId);
    }
    if (subdId != null) {
      selectedSubdistrict.value = subdId;
      await fetchWards(subdId);
    }
    if (wardId != null) {
      selectedWard.value = wardId;
      await fetchZipcodes(wardId);
      // set selectedZipcode if the zip list contains the zip
      selectedZipcode.value = zip;
    }
  }
}
