import 'dart:developer';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:in_app_update/in_app_update.dart';
import 'package:odda/app/model/update_app_data.dart';
import 'package:odda/app/repository/app_update_repository.dart';
import 'package:odda/common/app_update_dialogue.dart';
import 'package:odda/common/color_constants.dart';
import 'package:odda/common/utils.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:flutter_svg/svg.dart';
import '../../../common/preferences.dart';
import '../../../main.dart';
import '../../routes/app_routes.dart';

class RootView extends StatefulWidget {
  const RootView({super.key});

  @override
  State<RootView> createState() => _RootViewState();
}

class _RootViewState extends State<RootView> {
  late UpdateAppRepository updateAppRepository;

  @override
  void initState() {
    super.initState();
    checkAppVersion();
    // checkForUpdate();
  }

// by api
  void checkAppVersion() async {
    try {
      UpdateAppData response = await UpdateAppRepository().getUpdateApp();

      if(response.data!=null){
        PackageInfo packageInfo = await PackageInfo.fromPlatform();
        String version = packageInfo.version;
        String buildNumber = packageInfo.buildNumber;


          log('Platform.isIOS ${Platform.isIOS}');
          print('Platform.isIOS ${Platform.isIOS}');
          log('packageInfo::appVersion::$version and buildNumber::$buildNumber');
          print('packageInfo::appVersion::$version and buildNumber::$buildNumber');


        // from api
        var androidVersion = response.data?.androidVersion;
        var iosVersion = response.data?.iosVersion;
        var playStoreUrl = response.data?.playStoreUrl;
        var appStoreUrl = response.data?.appStoreUrl;

        // log('packageInfo::appVersion::$version');

        if(Platform.isAndroid && androidVersion==version || Platform.isIOS && iosVersion==version){
          Future.delayed(const Duration(seconds: 3), () {

            Get.offAllNamed(Routes.Middle);
            // ForceUpdateAppDialog.show(context);
            print("testing if worked");
            if(!isNotificationOpened){
              // Get.offAllNamed(Routes.Home);
              print(getValue(SharedPref.currencyCode));
              if(getValue(SharedPref.currencyCode)=="null"){

                storeValue(SharedPref.currency, 'KSh');
                storeValue(SharedPref.currencyCode, 'KES');
              }

            }
          });
        }  else {
          ForceUpdateAppDialog.show(Get.context!,Platform.isAndroid?playStoreUrl.toString():appStoreUrl.toString());
        }
      }

    } catch (e) {
      if (e is DioException) {
        print('Upper ===  ' + e.response?.data);
      } else {
        // Get.snackbar('', e.toString());
        print('Lower =checkAppVersion==  $e');
      }
    }
  }



  AppUpdateInfo? _updateInfo;
  Future<void> checkForUpdate() async {
    InAppUpdate.checkForUpdate().then((info) {
      setState(() {
        _updateInfo = info;
        _updateInfo?.updateAvailability ==
            UpdateAvailability.updateAvailable
            ? () {
          InAppUpdate.performImmediateUpdate()
              .catchError((e) {
            showSnack(e.toString());
            return AppUpdateResult.inAppUpdateFailed;
          });
        }: null;
      });
    }).catchError((e) {
      showSnack(e.toString());
    });
  }
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();
  void showSnack(String text) {
    if (_scaffoldKey.currentContext != null) {
      ScaffoldMessenger.of(_scaffoldKey.currentContext!)
          .showSnackBar(SnackBar(content: Text(text)));
    }
  }




  // 2105 1100 1329

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(gradient: getBgGradient()),
        width: 100.w,
        height: 100.h,
        child: Stack(
          children: [
            // SvgPicture.asset('assets/images/root_bg.svg',width: 100.w,height: 100.h,fit: BoxFit.cover,),
            Align(
                alignment: Alignment.center,
                child: SvgPicture.asset(
                  'assets/images/path.svg',
                  width: 100.w,
                  fit: BoxFit.contain,
                )),
            Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(
                  height: 25.h,
                ),
                SizedBox(
                  width: 100.w,
                  child: SvgPicture.asset(
                    'assets/images/app_logo.svg',
                    width: 60.w,
                    fit: BoxFit.contain,
                  ),
                ),
                Expanded(child: Container()),
                addAlignedText(
                    'Order medication online\nFind distributors & exporters',
                    getLargeTextFontSIze(),
                    colorConstants.white,
                    FontWeight.normal),
                SizedBox(
                  height: 5.h,
                ),
                // Center(
                //     child: SliderButton(
                //   backgroundColor: colorConstants.primaryDark,
                //   width: 80.w,
                //   height: 60,
                //   alignLabel: Alignment.center,
                //   action: () {
                //     Get.toNamed(Routes.Splash);
                //   },
                //   label: addAlignedText('Get Started', getHeadingTextFontSIze(),
                //       colorConstants.white, FontWeight.w500),
                //   shimmer: false,
                //   buttonSize: 45,
                //   icon: Container(
                //     margin: const EdgeInsets.all(10),
                //     child: SvgPicture.asset(
                //       'assets/images/ic_slider.svg',
                //       height: double.infinity,
                //     ),
                //   ),
                // )),
                SizedBox(
                  height: 10.h,
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}
