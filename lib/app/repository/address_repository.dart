import 'package:get/get.dart';

import '../model/add_address_data.dart';
import '../model/normal_response.dart';
import '../provider/api_provider.dart';

class AddressRepository{

  late ApiProvider _apiProvider;

  AddressRepository(){
    _apiProvider = Get.find<ApiProvider>();
  }

  Future<AddAddressData> addAddress(
      String address, String pin, String addressType, String mobileNo,String city,String state,String lat,String lng) async {
    return _apiProvider.addAddress(address, pin, addressType, mobileNo, city, state, lat, lng);
  }

  Future<AddAddressData> getAddressList() async {
    return _apiProvider.getAddressList();
  }

  Future<NormalResponse> setDefaultAddress(String addressId) async {
    return _apiProvider.setDefaultAddress(addressId);
  }

  Future<NormalResponse> deleteAddress(String addressId) async {
    return _apiProvider.deleteAddress(addressId);
  }

}