import 'package:currency_picker/currency_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:odda/app/ui/web_view/web_view.dart';
import 'package:odda/common/color_constants.dart';
import 'package:odda/common/preferences.dart';
import 'package:odda/common/utils.dart';
import 'package:posthog_flutter/posthog_flutter.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

import '../app/controller/home_controller.dart';
import '../app/routes/app_routes.dart';

class AppDrawer extends GetView<HomeController> {
  const AppDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: colorConstants.white,
      width: 60.w,
      height: 100.h,
      child: SafeArea(
          child: Stack(
        children: [
          ListView(
            // crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: 5.h,
              ),
              Align(
                alignment: Alignment.topLeft,
                child: Padding(
                  padding: const EdgeInsets.only(left: 20),
                  child: SvgPicture.asset(
                    'assets/images/app_logo_blue.svg',
                    height: 7.h,
                  ),
                ),
              ),
              Divider(
                height: 6.h,
              ),
              GestureDetector(
                onTap: () {
                  Get.back();
                },
                child: buildItems('menu_home.svg', 'Home'),
              ),
             /* GestureDetector(
                onTap: () {
                  Get.back();
                  Get.toNamed(Routes.Category);
                },
                child: buildItems('menu_category.svg', 'Category'),
              ),*/
              GestureDetector(
                onTap: () {
                  Get.back();
                  Get.toNamed(Routes.ProductView, arguments: {
                    'title': 'Latest Items',
                    'categoryId': '10000',
                    'itemType' : 'latest',
                    'bannerId': '',
                    'isBannerproduct': false,
                    'isBanner': false,
                    'ad_id': "",
                  });
                },
                child: buildItems('menu_latest.svg', 'Latest Items'),
              ),
              GestureDetector(
                onTap: () {
                  Get.back();
                  Get.toNamed(Routes.ProductView, arguments: {
                    'title': 'Popular Items',
                    'categoryId': '10000',
                    'itemType' : 'popularity',
                    'bannerId': '',
                    'isBanner': false,
                    'isBannerproduct': false,
                    'ad_id': "",
                  });
                },
                child: buildItems('menu_popular.svg', 'Popular Items'),
              ),
              GestureDetector(
                onTap: () {
                  Get.back();
                  Get.toNamed(Routes.ProductView, arguments: {
                    'title': 'Featured Items',
                    'categoryId': '10000',
                    'itemType' : 'featured',
                    'isBannerproduct': false,
                    'bannerId': '',
                    'ad_id': "",
                    'isBanner': false,
                  });
                },
                child: buildItems('menu_featured.svg', 'Featured Items'),
              ),
              GestureDetector(
                onTap: () async {
                  Get.back();
                  Get.toNamed(Routes.JobApplicantView);
                  await Posthog().capture(eventName: 'clicked_on_locum',properties: {
                    'user_id': getValue(SharedPref.userId),
                    'user_name': getValue(SharedPref.userName),
                    'mobile_no': getValue(SharedPref.mobileNo),
                  });
                },
                child: Row(
                  children: [
                    const SizedBox(
                      width: 20,
                    ),
                    const Icon(
                      Icons.group_work_outlined,
                      color: colorConstants.buttonColor,
                    ),
                    const SizedBox(
                      width: 20,
                    ),
                    addText('Locum', getNormalTextFontSIze() - 1, colorConstants.black, FontWeight.bold)
                  ],
                ),
              ),

              Divider(
                height: 3.h,
              ),
              Padding(
                padding: const EdgeInsets.only(left: 20, top: 10),
                child: addText('User Info', getSmallTextFontSIze(),
                    colorConstants.black, FontWeight.bold),
              ),
              const SizedBox(
                height: 20,
              ),
              GestureDetector(
                onTap: () {
                  Get.back();
                  if (GetStorage().hasData(SharedPref.authToken)) {
                    Get.toNamed(Routes.Profile);
                  } else {
                    Get.toNamed(Routes.Login);
                  }
                },
                child: buildItems('menu_profile.svg', 'Profile'),
              ),

              GestureDetector(
                onTap: () async {
                  Get.back();
                  if (GetStorage().hasData(SharedPref.authToken)) {
                    Get.toNamed(Routes.VendorChats);
                    await Posthog().capture(eventName: 'clicked_on_chats',properties: {
                      'user_id': getValue(SharedPref.userId),
                      'user_name': getValue(SharedPref.userName),
                      'mobile_no': getValue(SharedPref.mobileNo),
                    });
                  } else {
                    Get.toNamed(Routes.Login);
                  }
                },
                child: Row(
                  children: [
                    const SizedBox(
                      width: 20,
                    ),
                    const Icon(
                      Icons.chat,
                      color: colorConstants.buttonColor,
                    ),
                    const SizedBox(
                      width: 20,
                    ),
                    addText('Chats', getNormalTextFontSIze() - 1,
                        colorConstants.black, FontWeight.bold)
                  ],
                ),
              ),

              Divider(
                height: 3.h,
              ),
              Padding(
                padding: const EdgeInsets.only(left: 20, top: 10),
                child: addText('App', getSmallTextFontSIze(),
                    colorConstants.black, FontWeight.bold),
              ),
              const SizedBox(
                height: 20,
              ),
              GestureDetector(
                onTap: () {
                  Get.back();
                  if (GetStorage().hasData(SharedPref.authToken)) {
                    Get.toNamed(Routes.Contact);
                  } else {
                    Get.toNamed(Routes.Login);
                  }
                },
                child: buildItems('menu_contact.svg', 'Contact us'),
              ),
              GestureDetector(
                onTap: () async {
                  Get.back();
                  if (GetStorage().hasData(SharedPref.authToken)) {
                    Get.toNamed(Routes.Cart);
                    await Posthog().capture(eventName: 'clicked_on_cart',properties: {
                      'user_id': getValue(SharedPref.userId),
                      'user_name': getValue(SharedPref.userName),
                      'mobile_no': getValue(SharedPref.mobileNo),
                    });
                  } else {
                    Get.toNamed(Routes.Login);
                  }
                },
                child: Row(
                  children: [
                    const SizedBox(
                      width: 20,
                    ),
                    const Icon(
                      Icons.shopping_cart_rounded,
                      color: colorConstants.buttonColor,
                    ),
                    const SizedBox(
                      width: 20,
                    ),
                    addText('Cart', getNormalTextFontSIze() - 1,
                        colorConstants.black, FontWeight.bold)
                  ],
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              GestureDetector(
                onTap: () {
                  Get.back();
                  showCurrencyPicker(
                    context: context,
                    showSearchField: false,
                    theme: CurrencyPickerThemeData(
                      flagSize: 25,
                      titleTextStyle: const TextStyle(fontFamily: 'Nunito'),
                      subtitleTextStyle: const TextStyle(fontFamily: 'Nunito'),
                      bottomSheetHeight: MediaQuery.of(context).size.height / 2,
                    ),
                    onSelect: (Currency currency) {
                      storeValue(SharedPref.currency, currency.symbol);
                      storeValue(SharedPref.currencyCode, currency.code);
                      controller.getBanners();
                    },
                    currencyFilter: <String>['USD', 'KES'],
                  );
                },
                child: Row(
                  children: [
                    const SizedBox(
                      width: 20,
                    ),
                    const Icon(
                      Icons.currency_exchange,
                      color: colorConstants.buttonColor,
                    ),
                    const SizedBox(
                      width: 20,
                    ),
                    addText('Switch Currency', getNormalTextFontSIze() - 1,
                        colorConstants.black, FontWeight.bold)
                  ],
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              GestureDetector(
                onTap: () async {
                  Get.back();
                  Get.to(AppWebView(webUrl: 'https://www.oddaapp.com/appadmin/content/about_us', title: 'About Us'));
                  await Posthog().capture(eventName: 'clicked_on_about_us',properties: {
                    'user_id': getValue(SharedPref.userId),
                    'user_name': getValue(SharedPref.userName),
                    'mobile_no': getValue(SharedPref.mobileNo),
                  });
                },
                child: Row(
                  children: [
                    const SizedBox(
                      width: 20,
                    ),
                    const Icon(
                      Icons.info_outline_rounded,
                      color: colorConstants.buttonColor,
                    ),
                    const SizedBox(
                      width: 20,
                    ),
                    addText('About Us', getNormalTextFontSIze() - 1,
                        colorConstants.black, FontWeight.bold)
                  ],
                ),
              ),



              const SizedBox(
                height: 20,
              ),
              GestureDetector(
                onTap: (){
                  Get.back();
                  Get.to(AppWebView(webUrl: 'https://www.oddaapp.com/appadmin/content/privacy_policy', title: 'Privacy Policy'));
                },
                child: Row(
                  children: [
                    const SizedBox(
                      width: 20,
                    ),
                    const Icon(
                      Icons.privacy_tip_outlined,
                      color: colorConstants.buttonColor,
                    ),
                    const SizedBox(
                      width: 20,
                    ),
                    addText('Privacy Policy', getNormalTextFontSIze() - 1,
                        colorConstants.black, FontWeight.bold)
                  ],
                ),
              ),



              const SizedBox(
                height: 20,
              ),

            ],
          ),
          Positioned(
              top: 10,
              right: 10,
              child: GestureDetector(
                onTap: () => Get.back(),
                child: Icon(
                  Icons.close,
                  color: colorConstants.lightGrey,
                  size: getLargeTextFontSIze() * 1.2,
                ),
              ))
        ],
      )),
    );
  }

  Widget buildItems(String image, String title) {
    return Column(
      children: [
        Row(
          children: [
            const SizedBox(
              width: 20,
            ),
            SvgPicture.asset(
              'assets/images/$image',
              width: 20,
              color: colorConstants.buttonColor,
            ),
            const SizedBox(
              width: 20,
            ),
            addText(title, getNormalTextFontSIze() - 1, colorConstants.black,
                FontWeight.bold)
          ],
        ),
        SizedBox(
          height: 3.h,
        )
      ],
    );
  }
}
