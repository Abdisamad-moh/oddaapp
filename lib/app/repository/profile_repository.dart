import 'dart:io';

import 'package:get/get.dart';

import '../model/detail_review_data.dart';
import '../model/normal_response.dart';
import '../model/profile_data.dart';
import '../provider/api_provider.dart';

class ProfileRepository{

  late ApiProvider _apiProvider;

  ProfileRepository(){
    _apiProvider = Get.find<ApiProvider>();
  }

  Future<ProfileData> getProfile() async {
    return _apiProvider.getProfile();
  }

  Future<NormalResponse> updateProfile(String name, String email, String mobile,String about, File image,String countryCode) async {
    return _apiProvider.updateProfile(
        name, email, mobile, about, image,countryCode);
  }

  Future<DetailReviewData> getUserReview() async {
   return _apiProvider.getUserReview();
  }

}