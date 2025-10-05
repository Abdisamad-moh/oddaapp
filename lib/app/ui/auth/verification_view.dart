import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:odda/app/controller/auth_controller.dart';
import 'package:odda/common/color_constants.dart';
import 'package:odda/common/utils.dart';
import 'package:otp_text_field/otp_field.dart';
import 'package:otp_text_field/style.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class VerificationView extends GetView<AuthController>{
  const VerificationView({super.key});

  @override
  Widget build(BuildContext context) {
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
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 30),
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Expanded(child: Container()),
                SizedBox(height: 10.h,),
                Center(child: SvgPicture.asset('assets/images/app_logo_blue.svg')),
                SizedBox(height: 5.h,),
                addText('Verification Code', getLargeTextFontSIze(), colorConstants.black, FontWeight.bold),
                SizedBox(height: 2.h,),
                addText('Please enter the verification code', getNormalTextFontSIze(), colorConstants.greyTextColor, FontWeight.normal),
                SizedBox(height: 5.h,),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 0),
                  child:  OTPTextField(
                    length: 4,
                    width: 100.w,
                    fieldWidth: 15.w,
                    textFieldAlignment: MainAxisAlignment.spaceAround,
                    fieldStyle: FieldStyle.box,
                    outlineBorderRadius: 25,
                    // otpFieldStyle: OtpFieldStyle(
                    // ),
                    onChanged:(value) {},
                    keyboardType: TextInputType.number,
                    onCompleted: (pin) {
                      controller.enteredOtp.value = pin;
                    },
                  ),
                ),
                SizedBox(height: 4.h,),
                Obx(() => controller.isLoading.value ? getLoader() : GestureDetector(
                  onTap: (){
                    if(controller.enteredOtp.value.length < 4) {
                      showSnackbar(context, 'Please enter otp');
                    } else {
                      controller.verifyOtp(context);
                    }
                  },
                  child: getSolidButton(90.w, 'Verify'),
                ),),
                SizedBox(height: 1.5.h,),
                // GestureDetector(
                //   onTap: ()=>Get.toNamed(Routes.Home),
                //   child: addText('Resend OTP', getNormalTextFontSIze(), colorConstants.primaryColor2, FontWeight.bold),
                // ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}