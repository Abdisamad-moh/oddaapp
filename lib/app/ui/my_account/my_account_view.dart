import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:odda/app/controller/home_controller.dart';
import 'package:odda/common/color_constants.dart';
import 'package:odda/common/header.dart';
import 'package:odda/common/preferences.dart';
import 'package:odda/common/utils.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:share_plus/share_plus.dart';

import '../../routes/app_routes.dart';
import '../web_view/web_view.dart';

class MyAccountView extends StatefulWidget {
  const MyAccountView({super.key});

  @override
  State<MyAccountView> createState() => _MyAccountViewState();
}

class _MyAccountViewState extends State<MyAccountView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: colorConstants.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: AppHeader(
                  title: 'My Account',
                ),
              ),
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 20),
                padding: const EdgeInsets.all(15),
                decoration: BoxDecoration(
                    borderRadius: getCurvedBorderRadius(),
                    boxShadow: [getDeepBoxShadow()],
                    color: colorConstants.white),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        ClipRRect(
                          borderRadius: getBorderRadiusCircular(),
                          child: Obx(() => Image.network(
                            Get.find<HomeController>().userImage.value,
                            fit: BoxFit.cover,
                            width: 13.w,
                            height: 13.w,
                          )),
                        ),
                        const SizedBox(
                          width: 20,
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            addText('Welcome', getSmallTextFontSIze(),
                                colorConstants.lightGrey, FontWeight.normal),
                            addText(getValue(SharedPref.userName), getHeadingTextFontSIze(),
                                colorConstants.black, FontWeight.bold),
                          ],
                        )
                      ],
                    ),
                    GestureDetector(
                      onTap: () {
                        GetStorage().remove(SharedPref.isLogin);
                        GetStorage().remove(SharedPref.authToken);
                        GetStorage().remove(SharedPref.address);
                        // GetStorage().remove("countryCode");
                        // GetStorage().remove("loginCountryCode");
                        Get.offAllNamed(Routes.Login);
                      },
                      child: SvgPicture.asset(
                        'assets/images/logout.svg',
                        height: getLargeTextFontSIze() * 1.2,
                      ),
                    )
                  ],
                ),
              ),
              SizedBox(
                height: 5.h,
              ),
              GestureDetector(
                onTap: () {
                  Get.toNamed(Routes.MyOrders);
                },
                child: buildAccountItems('my_orders', 'My Orders'),
              ),
              GestureDetector(
                onTap: () {
                  Get.toNamed(Routes.OrderReportView);
                },
                child: Padding(
                  // padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
                  padding: const EdgeInsets.only(left: 15,right: 20,top: 15,bottom: 15),
                  child: Row(
                    children: [
                       Icon(Icons.report_outlined,color: colorConstants.greyTextColor,size: getLargeTextFontSIze() * 1.2),
                      const SizedBox(
                        width: 20,
                      ),
                      addText('My Order Reports', getSubheadingTextFontSIze(), colorConstants.black,
                          FontWeight.bold),
                      Expanded(child: Container()),
                      const Icon(Icons.arrow_forward_ios)
                    ],
                  ),
                ),
              ),
              GestureDetector(
                onTap: () {
                  Get.toNamed(Routes.Profile);
                },
                child: buildAccountItems('edit_profile', 'View/Edit Profile'),
              ),
              GestureDetector(
                onTap: () {
                  Get.toNamed(Routes.Address);
                },
                child: buildAccountItems('address_book', 'Address book'),
              ),
              GestureDetector(
                onTap: () {
                  Get.toNamed(Routes.Wishlist);
                },
                child: buildAccountItems('favourites', 'Favorites'),
              ),
              GestureDetector(
                onTap: () {
                  Get.toNamed(Routes.Contact);
                },
                child: buildAccountItems('contact', 'Contact Us'),
              ),
              GestureDetector(
                onTap: () {
                  if(GetPlatform.isAndroid){
                    Share.share('https://play.google.com/store/apps/details?id=com.app.odda');
                  } else {
                    Share.share('https://play.google.com/store/apps/details?id=com.app.odda');
                  }
                },
                child: buildAccountItems('share', 'Share the App'),
              ),
              GestureDetector(
                onTap: () {
                  GetStorage().remove(SharedPref.isLogin);
                  GetStorage().remove(SharedPref.authToken);
                  GetStorage().remove(SharedPref.address);
                  // GetStorage().remove("countryCode");
                  // GetStorage().remove("countryCode");
                  // GetStorage().remove("loginCountryCode");
                  Get.offAllNamed(Routes.Login);
                },
                child: Padding(
                  // padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
                  padding: const EdgeInsets.only(left: 15,right: 20,top: 15,bottom: 15),
                  child: Row(
                    children: [
                      Icon(Icons.login_outlined,color: colorConstants.greyTextColor,size: getLargeTextFontSIze() * 1.2),
                      const SizedBox(
                        width: 20,
                      ),
                      addText('Logout', getSubheadingTextFontSIze(), colorConstants.black,
                          FontWeight.bold),
                      Expanded(child: Container()),
                      const Icon(Icons.arrow_forward_ios)
                    ],
                  ),
                ),
              ),
              SizedBox(
                height: 5.h,
              ),

              InkWell(
                onTap: (){
                  Get.to(AppWebView(webUrl: 'https://www.oddaapp.com/appadmin/content/help', title: 'Help'));
                },
                child: Container(
                  margin: const EdgeInsets.symmetric(horizontal: 20),
                  padding: const EdgeInsets.symmetric(vertical: 15),
                  decoration: BoxDecoration(
                      color: const Color(0xFFDEECFF),
                      borderRadius: getCurvedBorderRadius()),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SvgPicture.asset('assets/images/support.svg'),
                      const SizedBox(
                        width: 20,
                      ),
                      addText('How can we help you?', getHeadingTextFontSIze(),
                          colorConstants.primaryColor, FontWeight.bold)
                    ],
                  ),
                ),
              ),
              SizedBox(height: 2.h,)
            ],
          ),
        ),
      ),
    );
  }

  Widget buildAccountItems(String image, String name) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
      child: Row(
        children: [
          SvgPicture.asset(
            'assets/images/$image.svg',
            color: colorConstants.black,
            width: getHeadingTextFontSIze() * 1.2,
          ),
          const SizedBox(
            width: 20,
          ),
          addText(name, getSubheadingTextFontSIze(), colorConstants.black,
              FontWeight.bold),
          Expanded(child: Container()),
          const Icon(Icons.arrow_forward_ios)
        ],
      ),
    );
  }
}
