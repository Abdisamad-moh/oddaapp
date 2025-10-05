import 'package:country_code_picker/country_code_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:odda/app/controller/auth_controller.dart';
import 'package:odda/app/routes/app_routes.dart';
import 'package:odda/common/color_constants.dart';
import 'package:odda/common/utils.dart';
import 'package:responsive_sizer/responsive_sizer.dart';


class LoginView extends GetView<AuthController>{
  const LoginView({super.key});

  @override
  Widget build(BuildContext context) {

    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark));

    return Scaffold(
      backgroundColor: colorConstants.white,
      /*appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading:   GestureDetector(
          onTap: () {
            Get.toNamed(Routes.Home);
            storeValue(SharedPref.currency, 'KSh');
            storeValue(SharedPref.currencyCode, 'KES');
          },
          child: const Icon(Icons.arrow_back_ios,color: Colors.black,),
        ),
      ),*/
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            width: 100.w,
            height: 92.h,
            padding: const EdgeInsets.symmetric(horizontal: 30),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Expanded(child: Container()),
                SizedBox(height: 20.h,),
                Center(child: SvgPicture.asset('assets/images/app_logo_blue.svg')),
                SizedBox(height: 5.h,),
                addText('Login', getLargeTextFontSIze(), colorConstants.black, FontWeight.bold),
                SizedBox(height: 2.h,),
                addText('Please enter the details below to continue.', getNormalTextFontSIze(), colorConstants.greyTextColor, FontWeight.normal),
                SizedBox(height: 5.h,),
                // addNumberEditText(controller.contactNoController, 'Mobile Number',inputFormatter: [FilteringTextInputFormatter.digitsOnly]),
                addNumberRegisterEditText(
                  controller.contactNoController, 'Mobile Number',inputFormatter: [

                    FilteringTextInputFormatter.digitsOnly,
                  FilteringTextInputFormatter.allow(RegExp(r'[0-9t]')),

                ],
                  leading: CountryCodePicker(
                    flagWidth: 20,
                    onChanged: (CountryCode? code) => controller.loginOnCountryCodeChanged(code),
                    initialSelection: 'Kenya',
                    favorite: const ['Kenya', '254','Somalia','+252'],
                    showCountryOnly: false,
                    showFlagMain: true,
                    alignLeft: false,
                    showFlag: true,
                    showFlagDialog: true,
                  ),


                  // prefixText: controller.countryCode.value,
                ),
                SizedBox(height: 2.h,),
                GestureDetector(
                  onTap: (){
                    if(controller.contactNoController.text.trim().isEmpty) {
                      showSnackbar(context, 'Please enter mobile number');
                    }else {
                      controller.loginAPI(context);
                    }

                  },
                  child: Obx(() => controller.isLoading.value ? getLoader() : getSolidButton(90.w, 'Log In')),
                ),
                GestureDetector(
                  child: Column(
                    children: [
                      const SizedBox(
                        height: 10,
                      ),
                      RichText(
                        text: TextSpan(
                          children: [
                            TextSpan(
                                text:
                                "Don't have an account? ",
                                style: TextStyle(
                                  fontFamily: 'Nunito',
                                  fontSize: getNormalTextFontSIze(),
                                  color: colorConstants.greyTextColor,
                                  fontWeight: FontWeight.normal,
                                )),
                            TextSpan(
                              text: "Register",
                              style: TextStyle(
                                  fontFamily: 'Nunito',
                                  fontSize: getNormalTextFontSIze(),
                                  color: colorConstants.primaryColor,
                                  fontWeight: FontWeight.bold,
                                  decoration: TextDecoration.underline),
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                  onTap: () {
                    Get.toNamed(Routes.SignUpView);
                  },
                ),
                // const Spacer(),
                // GestureDetector(
                //   onTap: (){
                //     Get.toNamed(Routes.Home);
                //     storeValue(SharedPref.currency, 'KSh');
                //     storeValue(SharedPref.currencyCode, 'KES');
                //   },
                //   child: getBorderButton(90.w, 'Browse as a guest'),
                // ),
                const SizedBox(height: 40,),



              ],
            ),
          ),
        ),
      ),
    );
  }

}