import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:odda/app/controller/home_controller.dart';
import 'package:odda/common/color_constants.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

import '../../../common/utils.dart';
import '../../controller/profile_controller.dart';
import '../../routes/app_routes.dart';

class ProfileView extends GetView<ProfileController> {
  const ProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: colorConstants.white,
      body: SafeArea(
        child: Obx(() => controller.isLoading.value
            ? SizedBox(
                height: 90.h,
                child: buildLoader(),
              )
            : Column(
                children: [
                  const SizedBox(
                    height: 20,
                  ),
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
                        addText('Profile', getHeadingTextFontSIze(),
                            colorConstants.black, FontWeight.w600),
                        GestureDetector(
                          onTap: () {
                            Get.toNamed(Routes.EditProfile);
                          },
                          child: Padding(
                            padding: const EdgeInsets.all(5.0),
                            child: addText('Edit', getSubheadingTextFontSIze(),
                                colorConstants.black, FontWeight.bold),
                          ),
                        )
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 4.h,
                  ),
                  SizedBox(
                    height: 15.h,
                    width: 15.h,
                    child: ClipRRect(
                      borderRadius: getBorderRadiusCircular(),
                      child: Image.network(
                        controller.profileDatum.image.toString(),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 2.h,
                  ),
                  addText(
                      controller.profileDatum.name.toString(),
                      getHeadingTextFontSIze(),
                      colorConstants.black,
                      FontWeight.bold),
                  // SizedBox(
                  //   height: 0.5.h,
                  // ),
                  // GestureDetector(
                  //   onTap: () {
                  //     Get.toNamed(Routes.DetailReview, arguments: {
                  //       'id': '',
                  //       'type': 'user',
                  //     });
                  //   },
                  //   child: Row(
                  //     mainAxisAlignment: MainAxisAlignment.center,
                  //     crossAxisAlignment: CrossAxisAlignment.center,
                  //     children: [
                  //       addText(
                  //           controller.profileDatum.rating.toString(),
                  //           getSmallTextFontSIze(),
                  //           colorConstants.black,
                  //           FontWeight.bold),
                  //       const SizedBox(
                  //         width: 5,
                  //       ),
                  //       RatingBar.builder(
                  //         itemSize: 15,
                  //         initialRating:
                  //             controller.profileDatum.rating.toDouble(),
                  //         minRating: 1,
                  //         ignoreGestures: true,
                  //         direction: Axis.horizontal,
                  //         allowHalfRating: true,
                  //         itemCount: 5,
                  //         itemBuilder: (context, _) => const Icon(
                  //           Icons.star,
                  //           color: colorConstants.buttonColor,
                  //         ),
                  //         onRatingUpdate: (rating) {
                  //           if (kDebugMode) {
                  //             print(rating);
                  //           }
                  //         },
                  //       ),
                  //       const SizedBox(
                  //         width: 5,
                  //       ),
                  //       addText(
                  //           '(${controller.profileDatum.totalReviews.toString()})',
                  //           getSmallTextFontSIze(),
                  //           colorConstants.black,
                  //           FontWeight.bold),
                  //     ],
                  //   ),
                  // ),
                  SizedBox(
                    height: 0.5.h,
                  ),
                  addText(
                      controller.profileDatum.mobileNo.toString(),
                      getNormalTextFontSIze() - 1,
                      colorConstants.black,
                      FontWeight.normal),
                  SizedBox(
                    height: 2.h,
                  ),
                  if (controller.profileDatum.about != null)
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: addAlignedText(
                          controller.profileDatum.about.toString(),
                          getSmallTextFontSIze(),
                          colorConstants.black,
                          FontWeight.normal),
                    ),
                  SizedBox(
                    height: 2.h,
                  ),
                  const Divider(),
                  SizedBox(
                    height: 2.h,
                  ),
                  Align(
                    alignment: Alignment.topLeft,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: addText(
                          'Joined On ${DateFormat("d MMMM yyyy hh:mm a").format(DateTime.parse(controller.profileDatum.createdAt.toString()))}',
                          getSmallTextFontSIze(),
                          colorConstants.black,
                          FontWeight.bold),
                    ),
                  ),
                  Align(
                      alignment: Alignment.topLeft,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: addText('Verified', getSmallTextFontSIze(),
                            colorConstants.black, FontWeight.bold),
                      )),
                  Expanded(child: Container()),
                  GestureDetector(
                    onTap: () {
                      Get.find<HomeController>().deleteAccount();
                    },
                    child: addText('Delete Account', getNormalTextFontSIze(),
                        Colors.black, FontWeight.bold),
                  ),
                  SizedBox(
                    height: 2.h,
                  ),
                ],
              )),
      ),
    );
  }
}
