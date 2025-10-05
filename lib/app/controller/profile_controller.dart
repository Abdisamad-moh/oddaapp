import 'dart:io';

import 'package:country_code_picker/country_code_picker.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

import '../../common/preferences.dart';
import '../../common/utils.dart';
import '../model/normal_response.dart';
import '../model/profile_data.dart';
import '../repository/profile_repository.dart';
import 'home_controller.dart';

class ProfileController extends GetxController{

  final desc = "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type...";

  late TextEditingController nameController;
  late TextEditingController emailController;
  late TextEditingController phoneController;
  late TextEditingController aboutMeController;
  final showEmail = false.obs;
  final showPhone = false.obs;
  late ProfileRepository profileRepository;
  final isLoading = false.obs;
  final isUpdating = false.obs;
  late ProfileDatum profileDatum;
  final countryCodeFromApi = '+254'.obs; // changed by lokesh 91 to 254
  final imageUrl = ''.obs;
  final picker = ImagePicker();
  final imagePicked = false.obs;
  final pickedFile = XFile('').obs;
  int? countryCode ;
  String? countryCodeFromPicker;
  final TextEditingController countryCodePickerController = TextEditingController();
  void onCountryCodeChanged(CountryCode? code) {
    // countryCode = int.tryParse(code?.dialCode.toString() ?? '');
    // countryCodePickerController.text = code.toString();
    // countryCodeFromPicker = '+${countryCode.toString()}';
    // Get.log("countryCode:${countryCodePickerController.text}");
    // Get.log("countryCodeValue:${countryCode}");
    // Get.log("countryCodeFromPicker:${countryCodeFromPicker}");

    countryCode = int.tryParse(code?.dialCode.toString() ?? '');
    countryCodePickerController.text = code.toString();
    countryCodeFromPicker = code?.dialCode;
    Get.log("countryCode:${countryCodePickerController.text}");
    Get.log("countryCodeValue:$countryCode");
    Get.log("countryCodeFromPicker:$countryCodeFromPicker");
  }
  // }

  ProfileController(){
    profileRepository = ProfileRepository();
    nameController = TextEditingController(text: 'Roy Smith');
    emailController = TextEditingController(text: 'vijay_kumar65@gmail.com');
    phoneController = TextEditingController(text: '+1 9865945896');
    aboutMeController = TextEditingController(text: 'About me');
  }

  @override
  void onInit(){
    super.onInit();
    getProfile();
  }

  void getProfile() async {
    isLoading.value = true;
    ProfileData profileData = await profileRepository.getProfile();
    Get.log("profileData:${profileData.data.countryCode}");
    profileDatum = profileData.data;
    countryCodeFromApi.value = '${profileDatum.countryCode}';
    isLoading.value = false;
    setValues(profileDatum);
    try {

    } catch (e) {
      isLoading.value = false;
      if (e is DioException) {
        if (kDebugMode) {
          print('Upper ===  ' + e.response!.data);
        }
      } else {
        Get.snackbar('', e.toString());
        if (kDebugMode) {
          print('Lower ===  $e');
        }
      }
    }
  }

  void setValues(ProfileDatum profileDatum){
    nameController = TextEditingController(text: profileDatum.name == null ? '' : profileDatum.name.toString());
    emailController = TextEditingController(text: profileDatum.email == null ? '' : profileDatum.email.toString());
    phoneController = TextEditingController(text: profileDatum.mobileNo == null ? '' : profileDatum.mobileNo.toString());
    aboutMeController = TextEditingController(text: profileDatum.about == null ? '' : profileDatum.about.toString());
    imageUrl.value = profileDatum.image.toString();
    // countryCodeFromApi.value = '${profileDatum.countryCode}';
    Get.log("getCodeFromApi:$countryCodeFromApi");
    storeValue(SharedPref.userImage, profileDatum.image.toString());
    Get.find<HomeController>().userImage.value = profileDatum.image.toString();
  }

  Future<void> imgFromGallery() async {
    pickedFile.value = (await picker.pickImage(source: ImageSource.gallery, imageQuality: 20))!;
    imagePicked.value = true;
  }

  Future<void> imgFromCamera() async {
    pickedFile.value =
    (await picker.pickImage(source: ImageSource.camera, imageQuality: 20))!;
    imagePicked.value = true;
  }

  void updateProfile(BuildContext context) async {
    try {
      isUpdating.value = true;
      NormalResponse normalResponse = await profileRepository.updateProfile(
          nameController.text.trim(),
          emailController.text.trim(),
          phoneController.text.trim(),
          aboutMeController.text.trim(),
          File(pickedFile.value.path),
          countryCodeFromPicker.toString()
          // selectedCode.value
      );
      isUpdating.value = false;
      Get.back();
      getProfile();
    } catch (e) {
      isUpdating.value = false;
      if (e is DioException) {
        showSnackbar(context, e.response!.data['msg']);
      } else {
        showSnackbar(context, e.toString());
      }
    }
  }





}