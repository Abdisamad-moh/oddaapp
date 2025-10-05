import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:in_app_update/in_app_update.dart';
import 'package:odda/common/color_constants.dart';
import 'package:odda/common/utils.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import '../../routes/app_routes.dart';
import '../../services/auth_service.dart';

class SplashView extends StatefulWidget {
  const SplashView({super.key});

  @override
  State<SplashView> createState() => _SplashViewState();
}

class _SplashViewState extends State<SplashView> {
  @override
void initState() {
  super.initState();

  // Comment out in-app update for emulator/dev testing
  // checkForUpdate();

  Future.delayed(const Duration(seconds: 3), () {
    final authService = Get.find<AuthService>();
    if (!authService.isLogin) {
      Get.offNamed(Routes.Login);
    } else {
      Get.offNamed(Routes.Home);
    }
  });
}
  AppUpdateInfo? _updateInfo;
  final bool _flexibleUpdateAvailable = false;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();
  // Platform messages are asynchronous, so we initialize in an async method.
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

  void showSnack(String text) {
    if (_scaffoldKey.currentContext != null) {
      ScaffoldMessenger.of(_scaffoldKey.currentContext!)
          .showSnackBar(SnackBar(content: Text(text)));
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: colorConstants.primaryDark,
      body: Container(
        decoration: BoxDecoration(gradient: getBgGradient()),
        width: 100.w,
        height: 100.h,
        child: Stack(
          children: [
            Positioned(
               left: 0,
                right: 0,
                bottom: 0,
                child: Image.asset(
                  'assets/images/splash_bgg.png',
                  width: 100.w,
                  fit: BoxFit.contain,
                )),
            Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(
                  height: 10.h,
                ),
                SizedBox(
                  width: 100.w,
                  child: SvgPicture.asset(
                    'assets/images/app_logo.svg',
                    width: 60.w,
                    fit: BoxFit.contain,
                  ),
                ),
                SizedBox(
                  height: 10.h,
                ),
                addAlignedText(
                    'Order medication online\nFind distributors',
                    getLargeTextFontSIze(),
                    colorConstants.white,
                    FontWeight.normal),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
