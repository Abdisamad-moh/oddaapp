
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

import '../routes/app_routes.dart';
import '../services/auth_service.dart';


class AuthMiddleware extends GetMiddleware {
  @override
  RouteSettings? redirect(String? route) {
    final authService = Get.find<AuthService>();

    return !authService.isLogin
        ? RouteSettings(name: Routes.Login) : RouteSettings(name: Routes.Home);
  }
}
