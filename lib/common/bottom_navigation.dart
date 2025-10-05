import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:odda/common/color_constants.dart';
import 'package:odda/common/preferences.dart';
import 'package:odda/common/utils.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

import '../app/routes/app_routes.dart';

class AppBottomNavigation extends StatefulWidget {
  const AppBottomNavigation({super.key});

  @override
  State<AppBottomNavigation> createState() => _AppBottomNavigationState();
}

class _AppBottomNavigationState extends State<AppBottomNavigation> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      height: 8.h,
      decoration: BoxDecoration(
          borderRadius: getBorderRadiusCircular(),
          // color: colorConstants.black
          gradient: getButtonGradient()),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          GestureDetector(
            onTap: () {
              if (Get.currentRoute != Routes.Home) {
                // Get.toNamed(Routes.Home);
                Get.offAllNamed(Routes.Home);
              }
            },
            child: SvgPicture.asset('assets/images/ic_home.svg'),
          ),

          GestureDetector(
            onTap: () {
              if (Get.currentRoute != Routes.Cart) {
                if (GetStorage().hasData(SharedPref.authToken)) {
                  Get.toNamed(Routes.Cart);
                } else {
                  Get.toNamed(Routes.Login);
                }
              }
            },
            child: SvgPicture.asset('assets/images/cart.svg',color: colorConstants.white,width: 21,height: 21,),
          ),

          // GestureDetector(
          //   onTap: (){
          //     // Get.toNamed(Routes.AddProductView);
          //   }, child: Container(
          //   height: 6.5.h,
          //   width: 6.5.h,
          //   padding: EdgeInsets.all(2.2.h),
          //   decoration: BoxDecoration(
          //     color: colorConstants.white,
          //     shape: BoxShape.circle
          //   ), child: SvgPicture.asset('assets/images/ic_add.svg',color: Color(0xFF5A97E8),),
          // ),
          // ),

          GestureDetector(
            onTap: () {
              if (GetStorage().hasData(SharedPref.authToken)) {
                Get.toNamed(Routes.Wishlist);
              } else {
                Get.toNamed(Routes.Login);
              }
            },
            child: SvgPicture.asset(
              'assets/images/non_favourite.svg',
              color: colorConstants.white,
            ),
          ),

          GestureDetector(
            onTap: () {
              if (GetStorage().hasData(SharedPref.authToken)) {
                Get.toNamed(Routes.MyAccount);
              } else {
                Get.toNamed(Routes.Login);
              }
            },
            child: SvgPicture.asset('assets/images/ic_profile.svg'),
          ),
        ],
      ),
    );
  }
}
