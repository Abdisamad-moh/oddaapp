import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:odda/main.dart';

import '../routes/app_routes.dart';


class NotificationMiddleware extends GetMiddleware {
  @override
  RouteSettings? redirect(String? route) {
    return isNotificationOpened
        ? null : const RouteSettings(name: Routes.Root);
  }
}
