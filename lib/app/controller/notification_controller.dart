import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';

import '../model/notification_data.dart';
import '../repository/notification_repository.dart';
import 'home_controller.dart';

class NotificationController extends GetxController{

  late NotificationRepository notificationRepository;
  final isLoading = false.obs;
  final notificationList = <Datum>[].obs;

  NotificationController() {

    notificationRepository = NotificationRepository();
  }

  @override
  void onInit() {
    super.onInit();
    getNotifications();
    Future.delayed(const Duration(seconds: 1), () {
      Get.find<HomeController>().isNewNotification.value = false;
    });
  }

  void getNotifications() async {
    try {
      isLoading.value = true;
      NotificationData notificationData =
      await notificationRepository.getNotifications();
      notificationList.assignAll(notificationData.data);
      isLoading.value = false;
    } catch (e) {
      isLoading.value = false;
      if (e is DioException) {
        if (kDebugMode) {
          print('Upper ===   ${e.response!.data} ');
        }
      } else {
        if (kDebugMode) {
          print('Lower ===  $e');
        }
      }
    }
  }

}