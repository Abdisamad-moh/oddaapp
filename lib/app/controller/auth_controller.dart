// ignore_for_file: use_build_context_synchronously

import 'package:country_code_picker/country_code_picker.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:odda/app/model/login_data.dart';
import 'package:odda/app/model/otp_data.dart';
import 'package:odda/app/repository/auth_repository.dart';
import 'package:odda/app/services/auth_service.dart';
import 'package:odda/common/preferences.dart';
import 'package:posthog_flutter/posthog_flutter.dart';

import '../../common/utils.dart';
import '../routes/app_routes.dart';

class AuthController extends GetxController {
  final hideLoginPassword = true.obs;
  late AuthRepository _authRepository;

  late TextEditingController businessNameController;
  late TextEditingController contactNoController;
  late TextEditingController licenseNumberController;
  final hidePassword = true.obs;
  final hideConfirmPassword = true.obs;
  final isLoading = false.obs;
  RxString selectedType = 'pharmacy'.obs;

  final isChecked = false.obs;
  bool isLastRouteProduct = false;

  final List<String> categoryItems = [
    'Item1',
    'Item2',
    'Item3',
    'Item4',
  ];
  final categorySelectedItem = 'Selected Value'.obs;

  final enteredOtp = ''.obs;
  int? countryCode ;
  String? countryCodeFromPicker;
  // final TextEditingController countryCodePickerController = TextEditingController();
  // void onCountryCodeChanged(CountryCode? code) {
  //   countryCode = int.tryParse(code?.dialCode.toString() ?? '');
  //   countryCodePickerController.text = code.toString();
  //   countryCodeFromPicker = countryCode.toString();
  //   Get.log("countryCode:${countryCodePickerController.text}");
  //   Get.log("countryCodeValue:${countryCode}");
  //   Get.log("countryCodeFromPicker:${countryCodeFromPicker}");
  // }

  void onCountryCodeChanged(CountryCode? code) {
    countryCode = int.tryParse(code?.dialCode.toString() ?? '');
    // countryCodePickerController.text = code.toString();
    countryCodeFromPicker = code?.dialCode;
    AuthService().saveCountryCode("countryCode", countryCodeFromPicker??"");
    // Get.log("countryCode:${countryCodePickerController.text}");
    Get.log("countryCodeValue:$countryCode");
    Get.log("countryCodeFromPicker:$countryCodeFromPicker");
  }


  int? loginCountryCode ;
  String? loginCountryCodeFromPicker = '+254';

  void loginOnCountryCodeChanged(CountryCode? code) {
    loginCountryCode = int.tryParse(code?.dialCode.toString() ?? '');
    // countryCodePickerController.text = code.toString();
    loginCountryCodeFromPicker = code?.dialCode??'';

    AuthService().saveCountryCode("loginCountryCode", loginCountryCodeFromPicker??"");
    // AuthService().saveCountryCode("countryCode", loginCountryCodeFromPicker??"");
    // Get.log("countryCode:${countryCodePickerController.text}");
    Get.log("loginCountryCode:$loginCountryCode");
    Get.log("loginCountryCodeFromPicker:$loginCountryCodeFromPicker");
  }

  AuthController() {
    _authRepository = AuthRepository();
    businessNameController = TextEditingController();
    contactNoController = TextEditingController();
    licenseNumberController = TextEditingController();
  }

  void loginAPI(BuildContext context) async {
    Get.focusScope!.unfocus();
    try {
      isLoading.value = true;
      LoginData loginData = await _authRepository.loginAPI(
          contactNoController.text.trim(),
          // loginCountryCodeFromPicker?? "+254"
          loginCountryCodeFromPicker.toString()
      );
      if(Get.previousRoute == Routes.ProductDetail){
        isLastRouteProduct = true;
      }
      showSnackbar(context, loginData.msg);
      Get.toNamed(Routes.Verification);
      isLoading.value = false;
    } catch (e) {
      isLoading.value = false;
      if (e is DioException) {
        Get.log(e.response!.data.toString());
        showSnackbar(context, e.response!.data['msg'].toString());
      } else {
        showSnackbar(context, e.toString());
        Get.log(e.toString());
      }
    } finally {
      isLoading.value = false;
    }
  }






  void sendOTP(BuildContext context) async {
    Get.focusScope!.unfocus();
    try {
      isLoading.value = true;
      LoginData loginData = await _authRepository.sendOTP(
          selectedType.value, 
          businessNameController.text.toString(),
          contactNoController.text.trim(),
        licenseNumberController.text.trim(),
          countryCodeFromPicker ?? "+254"
      );

      // Get.log("loginData:${loginData.countryCode.toString()}");
      // String val = loginData.countryCode.toString()??'';
      // Get.log("loginData:${val}");

      Get.log("sendCountryCode:${countryCodeFromPicker.toString()}");

      if(Get.previousRoute == Routes.ProductDetail){
        isLastRouteProduct = true;
      }
      showSnackbar(context, loginData.msg);
      Get.toNamed(Routes.Verification);
      isLoading.value = false;
    } 
    catch (e) {
      isLoading.value = false;
      if (e is DioException) {
        Get.log("dioErrorRegister${e.response!.data}");
        showSnackbar(context, e.response!.data['msg']);
      } else {
        Get.log("elseError:${e.toString()}");
        showSnackbar(context, e.toString());
      }
      Get.log("RegisterError:$e");
    } finally {
      isLoading.value = false;
    }
  }


  void verifyOtp(BuildContext context) async {

    Get.focusScope!.unfocus();
    try {
      isLoading.value = true;
      OtpData otpData;

      if(Get.previousRoute.toString() == Routes.Login){
        otpData = await _authRepository.verifyLoginOtp(enteredOtp.value, contactNoController.text.toString(), AuthService().getCountryCode("loginCountryCode")??"+254");

        await Posthog().capture(eventName: 'user_login',properties: {
          'user_id': otpData.data.id.toString(),
          'user_name': otpData.data.name.toString(),
          'mobile_no': otpData.data.mobileNo.toString(),
        });

      } else {
        otpData = await _authRepository.verifyOtp(enteredOtp.value, businessNameController.text.toString(), contactNoController.text.trim(),licenseNumberController.text.trim(),AuthService().getCountryCode("countryCode") ??"+254", selectedType.value);
      }

      // showSnackbar(context, otpData.token);
      storeValue(SharedPref.isLogin, 'true');
      storeValue(SharedPref.authToken, otpData.token.toString());
      storeValue(SharedPref.userName, otpData.data.name.toString());
      storeValue(SharedPref.userId, otpData.data.id.toString());
      storeValue(SharedPref.userImage, otpData.data.image.toString());
      storeValue(SharedPref.address, otpData.data.address.toString());
      storeValue(SharedPref.mobileNo, otpData.data.mobileNo.toString());
      // storeValue(SharedPref.currency, '\$');
      // storeValue(SharedPref.currencyCode, 'USD');
      storeValue(SharedPref.currency, 'KSh');
      storeValue(SharedPref.currencyCode, 'KES');
      if(isLastRouteProduct){
        Get.back();
        Get.back();
      } else {
        Get.offAllNamed(Routes.Home);
      }
      isLoading.value = false;
    } catch (e) {
      isLoading.value = false;
      if (e is DioException) {
        showSnackbar(context, e.response!.data['msg']);
        Get.log(e.response!.data['msg'].toString());
      } else {
        showSnackbar(context, e.toString());
      }
      Get.log(e.toString());
    } finally {
      isLoading.value = false;
    }
  }


  @override
  void onInit() { // added by lokesh
    // TODO: implement onInit
    AuthService().saveCountryCode("countryCode", "");
    AuthService().saveCountryCode("loginCountryCode", "");
    super.onInit();
  }


}
