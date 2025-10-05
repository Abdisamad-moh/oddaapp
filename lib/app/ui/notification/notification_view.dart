import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:odda/common/color_constants.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

import '../../../common/utils.dart';
import '../../controller/notification_controller.dart';

class NotificationView extends GetView<NotificationController> {
  const NotificationView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: colorConstants.white,
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  GestureDetector(
                    onTap: () {
                      Get.back();
                    },
                    child: const Icon(Icons.arrow_back_ios),
                  ),
                  addText('Notifications', getHeadingTextFontSIze(),
                      colorConstants.black, FontWeight.w600),
                  GestureDetector(
                    onTap: () {
                      Get.back();
                    },
                    child: const Icon(
                      Icons.arrow_back_ios,
                      color: colorConstants.white,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 2.h,
            ),
            Expanded(
                child: Obx(() => controller.isLoading.value
                    ? buildLoader()
                    : controller.notificationList.isEmpty
                        ? Center(
                            child: addText(
                                "You don't have any notifications",
                                getHeadingTextFontSIze(),
                                colorConstants.black,
                                FontWeight.w500),
                          )
                        : ListView.builder(
                            physics: const AlwaysScrollableScrollPhysics(),
                            shrinkWrap: true,
                            scrollDirection: Axis.vertical,
                            itemCount: controller.notificationList.length,
                            itemBuilder: (context, index) {
                              return GestureDetector(
                                  onTap: () {},
                                  child: Container(
                                      margin: const EdgeInsets.symmetric(
                                          vertical: 5, horizontal: 10),
                                      decoration: BoxDecoration(
                                        color: colorConstants.white,
                                        borderRadius: getCurvedBorderRadius(),
                                      ),
                                      child: Container(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 10),
                                        child: Column(
                                          children: [
                                            Row(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              children: [
                                                SizedBox(
                                                  width: 6.h,
                                                  height: 6.h,
                                                  child: ClipRRect(
                                                    borderRadius:
                                                        getBorderRadiusCircular(),
                                                    child: Image.network(
                                                      controller
                                                          .notificationList[
                                                              index]
                                                          .sender
                                                          .image,
                                                      fit: BoxFit.cover,
                                                    ),
                                                  ),
                                                ),
                                                const SizedBox(
                                                  width: 20,
                                                ),
                                                Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    SizedBox(
                                                        width: 60.w,
                                                        child: Text.rich(
                                                          TextSpan(
                                                            children: [
                                                              TextSpan(
                                                                text:
                                                                    '${controller.notificationList[index].title.toString()} : ',
                                                                style: const TextStyle(
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold),
                                                              ),
                                                              TextSpan(
                                                                text: controller
                                                                    .notificationList[
                                                                        index]
                                                                    .description
                                                                    .toString(),
                                                              ),
                                                            ],
                                                          ),
                                                        )),
                                                    SizedBox(
                                                      height: 0.5.h,
                                                    ),
                                                    addText(
                                                        controller
                                                            .notificationList[
                                                                index]
                                                            .timeToCreate,
                                                        getSmallTextFontSIze() -
                                                            1,
                                                        colorConstants
                                                            .greyTextColor,
                                                        FontWeight.w600),
                                                  ],
                                                )
                                              ],
                                            ),
                                            const SizedBox(
                                              height: 10,
                                            ),
                                            const Divider()
                                          ],
                                        ),
                                      )));
                            },
                          )))
          ],
        ),
      ),
    );
  }
}
