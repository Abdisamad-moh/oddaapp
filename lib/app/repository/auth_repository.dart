import 'package:get/get.dart';

import '../model/login_data.dart';
import '../model/otp_data.dart';
import '../provider/api_provider.dart';

class AuthRepository{

  late ApiProvider _apiProvider;

  AuthRepository(){
    _apiProvider = Get.find<ApiProvider>();
  }

  Future<LoginData> loginAPI(String mobileNo,String countryCode) async {
    return _apiProvider.loginAPI(mobileNo, countryCode);
  }

  Future<OtpData> verifyLoginOtp(String otp,  String mobileNo,String countryCode) async {
    return _apiProvider.verifyLoginOtp(otp, mobileNo, countryCode);
  }

  Future<LoginData> sendOTP(String type, String name, String mobileNo,String licenseNo,String countryCode) async {
    return _apiProvider.sendOTP(type, name, mobileNo,licenseNo,countryCode.toString());
  }

  Future<OtpData> verifyOtp(String otp, String name, String mobileNo,String licenseNo,String countryCode, String type) async {
    return _apiProvider.verifyOtp(otp, name, mobileNo,licenseNo, countryCode, type);
  }

}