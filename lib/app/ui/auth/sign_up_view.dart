import 'package:country_code_picker/country_code_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:odda/app/controller/auth_controller.dart';
import 'package:odda/app/services/auth_service.dart';
import 'package:odda/common/color_constants.dart';
import 'package:odda/common/utils.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

import '../web_view/web_view.dart';

class SignUpView extends GetView<AuthController>{
  const SignUpView({super.key});

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark));

    return Scaffold(
      backgroundColor: colorConstants.white,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading:   GestureDetector(
          onTap: () {
            Get.back();
          },
          child: const Icon(Icons.arrow_back_ios,color: Colors.black,),
        ),
      ),
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
                SizedBox(height: 10.h,),
                Center(child: SvgPicture.asset('assets/images/app_logo_blue.svg')),
                SizedBox(height: 5.h,),
                addText('Register ${AuthService().getCountryCode("countryCode")}', getLargeTextFontSIze(), colorConstants.black, FontWeight.bold),
                SizedBox(height: 2.h,),
                addText('Please enter the details below to continue.', getNormalTextFontSIze(), colorConstants.greyTextColor, FontWeight.normal),
                SizedBox(height: 5.h,),
                addEditText(controller.businessNameController, 'Business Name'),
                SizedBox(height: 1.5.h,),
            addNumberRegisterEditText(
              controller.contactNoController, 'Mobile Number',inputFormatter: [FilteringTextInputFormatter.digitsOnly],
              leading: CountryCodePicker(
                flagWidth: 20,
                onChanged: (CountryCode? code) => controller.onCountryCodeChanged(code),
                  initialSelection: 'Kenya',
                  // initialSelection: AuthService().getCountryCode("countryCode")==null?"Kenya":AuthService().getCountryCode("countryCode").toString(), // change by lokesh
                favorite: const ['Kenya', '+254','Somalia','+252'],
                showCountryOnly: false,
                showFlagMain: true,
                alignLeft: false,
                showFlag: true,
                showFlagDialog: true,
              ),


              // prefixText: controller.countryCode.value,
            ),
                SizedBox(height: 2.h,),
                addEditText(controller.licenseNumberController, 'License Number',),
                SizedBox(height: 2.h,),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Obx(() => Checkbox(
                      checkColor: Colors.white,
                      activeColor: colorConstants.primaryColor,
                      value: controller.isChecked.value,
                      side: const BorderSide(color: colorConstants.greyTextColor),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(3),
                      ),
                      onChanged: (bool? value) {
                        controller.isChecked.value = value!;
                      },
                    )),
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
                                    "Please confirm that you are agree to our ",
                                    style: TextStyle(
                                      fontFamily: 'Nunito',
                                      fontSize: getNormalTextFontSIze(),
                                      color: colorConstants.greyTextColor,
                                      fontWeight: FontWeight.normal,
                                    )),
                                TextSpan(
                                  text: "\nTerms & Conditions",
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
                        Get.to(AppWebView(webUrl: 'https://www.oddaapp.com/appadmin/content/terms_condition', title: 'Terms & Conditions'));
                      },
                    )
                  ],
                ),
                SizedBox(height: 2.h,),
                GestureDetector(
                  onTap: (){
                    if(controller.businessNameController.text.trim().isEmpty) {
                      showSnackbar(context, 'Please enter business name');
                    } else if(controller.contactNoController.text.trim().isEmpty) {
                      showSnackbar(context, 'Please enter mobile number');
                    }

                    if (controller.contactNoController.text.length < 7 || controller.contactNoController.text.length > 15) {
                      return  showSnackbar(context, 'Number must be between 7 and 15');
                    }

                    else if(controller.licenseNumberController.text.trim().isEmpty) {
                      showSnackbar(context, 'Please enter license number');
                    } else if(!controller.isChecked.value) {
                      showSnackbar(context, 'Please agree to our terms and conditions to proceed');
                    }else {
                      controller.sendOTP(context);
                    }

                  },
                  child: Obx(() => controller.isLoading.value ? getLoader() : getSolidButton(90.w, 'Create Account')),
                  // child: Obx(() => controller.isLoading.value ? getLoader() : getSolidButton(90.w, 'Log In')),
                ),




              ],
            ),
          ),
        ),
      ),
    );
  }

}