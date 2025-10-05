import 'package:get/get.dart';
import 'package:odda/app/provider/api_provider.dart';

import '../model/normal_response.dart';
import '../model/notification_data.dart';
import '../model/wishlist_data.dart';

class NotificationRepository {
  late ApiProvider _apiProvider;

  NotificationRepository() {
    _apiProvider = Get.find<ApiProvider>();
  }

  Future<NotificationData> getNotifications() async {
    return _apiProvider.getNotifications();
  }



}
