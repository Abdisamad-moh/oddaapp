import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:odda/app/repository/profile_repository.dart';

import '../model/detail_review_data.dart';
import '../repository/product_repository.dart';

class DetailReviewController extends GetxController{


  late ProductRepository productRepository;
  late ProfileRepository profileRepository;
  late DetailReviewData detailReviewData;
  final isLoading = false.obs;

  DetailReviewController() {
    productRepository = ProductRepository();
    profileRepository = ProfileRepository();
  }

  @override
  void onInit(){
    super.onInit();
    var type = Get.arguments['type'] as String;
    var id = Get.arguments['id'] as String;

    if(type == 'user'){
      getUserReview();
    }else {
      getReview(type,id);
    }
  }

  void getReview(String type,String itemId) async {
    try {
      isLoading.value = true;
      detailReviewData = await productRepository.getDetailReview(type,itemId);
      isLoading.value = false;
    } catch (e) {
      isLoading.value = false;
      if (e is DioException) {
        if (kDebugMode) {
          print(e.response!.data.toString());
        }
        Get.snackbar('', e.response!.data['msg']);
      } else {
        Get.snackbar('', e.toString());
        if (kDebugMode) {
          print(e.toString());
        }
      }
    } finally {
      isLoading.value = false;
    }
  }

  void getUserReview() async {
    try {
      isLoading.value = true;
      detailReviewData = await profileRepository.getUserReview();
      isLoading.value = false;
    } catch (e) {
      isLoading.value = false;
      if (e is DioException) {
        if (kDebugMode) {
          print(e.response!.data.toString());
        }
        Get.snackbar('', e.response!.data['msg']);
      } else {
        Get.snackbar('', e.toString());
        if (kDebugMode) {
          print(e.toString());
        }
      }
    } finally {
      isLoading.value = false;
    }
  }
}