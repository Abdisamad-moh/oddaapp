import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:odda/app/routes/app_routes.dart';
import 'package:odda/common/color_constants.dart';
import 'package:odda/common/preferences.dart';
import 'package:odda/common/utils.dart';
import 'package:posthog_flutter/posthog_flutter.dart';

import '../app/controller/home_controller.dart';

class LightAppHeader extends StatefulWidget {

  String title;

   LightAppHeader({super.key,required this.title});

  @override
  State<LightAppHeader> createState() => _LightAppHeaderState();
}

class _LightAppHeaderState extends State<LightAppHeader> {
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        GestureDetector(
          onTap: () {
            Get.back();
          },
          child: const Icon(Icons.arrow_back_ios,color: colorConstants.white,),
        ),
        addText(widget.title, getHeadingTextFontSIze(),
            colorConstants.white, FontWeight.w600),
        GestureDetector(
          onTap: () async {
            if (GetStorage().hasData(SharedPref.authToken)) {
              Get.toNamed(Routes.Notification);
              await Posthog().capture(eventName: 'clicked_on_notifications',properties: {
                'user_id': getValue(SharedPref.userId),
                'user_name': getValue(SharedPref.userName),
                'mobile_no': getValue(SharedPref.mobileNo),
              });
            } else {
              Get.toNamed(Routes.Login);
            }
          },
          child: Stack(
            children: [
              SvgPicture.asset('assets/images/notification.svg', color: colorConstants.white,),
              Obx(() => Get.find<HomeController>().isNewNotification.value ? Container(
                padding: const EdgeInsets.all(5),
                decoration: const BoxDecoration(
                    color: Colors.red,
                    shape: BoxShape.circle
                ),
              ) : const SizedBox.shrink()),
            ],
          ),
        )
      ],
    );
  }
}
