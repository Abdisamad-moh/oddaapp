import 'dart:io';

import 'package:country_code_picker/country_code_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:odda/common/color_constants.dart';
import 'package:odda/common/utils.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import '../../../common/header.dart';
import '../../controller/profile_controller.dart';

class EditProfileView extends GetView<ProfileController> {
  const EditProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: colorConstants.white,
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(
              height: 20,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: AppHeader(title: 'Profile'),
            ),
            SizedBox(
              height: 4.h,
            ),
            Expanded(
                child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: ListView(
                physics: const BouncingScrollPhysics(),
                children: [
                  Center(
                    child: SizedBox(
                      height: 15.h,
                      width: 15.h,
                      child: Stack(
                        children: [
                          ClipRRect(
                            borderRadius: getBorderRadiusCircular(),
                            child: Obx(() => Image.network(
                                controller.imageUrl.value,
                                fit: BoxFit.cover,
                                height: 15.h,
                                width: 15.h)),
                          ),
                          Obx(() => controller.imagePicked.value
                              ? ClipRRect(
                                  borderRadius: getBorderRadiusCircular(),
                                  child: Obx(() => Image.file(
                                        File(controller.pickedFile.value.path),
                                        height: 15.h,
                                        width: 15.h,
                                        fit: BoxFit.cover,
                                      )),
                                )
                              : Container()),
                          Positioned(
                              bottom: 5,
                              right: 5,
                              child: Container(
                                width: 35,
                                height: 35,
                                decoration: BoxDecoration(
                                    color: colorConstants.white,
                                    boxShadow: [getDeepBoxShadow()],
                                    shape: BoxShape.circle),
                                child: GestureDetector(
                                  onTap: () {
                                    _showPicker(context);
                                  },
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: SvgPicture.asset(
                                        'assets/images/ic_edt.svg'),
                                  ),
                                ),
                              ))
                        ],
                      ),
                    ),
                  ),

                  SizedBox(
                    height: 2.h,
                  ),
                  addText('User Name', getSmallTextFontSIze(),
                      colorConstants.black, FontWeight.bold),
                  const SizedBox(
                    height: 5,
                  ),
                  addEditText(controller.nameController, ''),

                  SizedBox(
                    height: 2.h,
                  ),
                  addText('Email', getSmallTextFontSIze(), colorConstants.black,
                      FontWeight.bold),
                  const SizedBox(
                    height: 5,
                  ),
                  addEditText(controller.emailController, ''),

                  SizedBox(
                    height: 2.h,
                  ),
                  addText('Phone', getSmallTextFontSIze(), colorConstants.black,
                      FontWeight.bold),
                  const SizedBox(
                    height: 5,
                  ),
                  // addEditText(controller.phoneController, ''),
                 Obx(() {
                   return  addNumberRegisterEditText(
                     controller.phoneController, 'Mobile Number',inputFormatter: [FilteringTextInputFormatter.digitsOnly],
                     leading: CountryCodePicker(
                       flagWidth: 20,
                       onChanged: (CountryCode? code) => controller.onCountryCodeChanged(code),
                       initialSelection: controller.countryCodeFromApi.value.toString()??"+254",
                       favorite: const ['Kenya', '254','Somalia','+252'],
                       showCountryOnly: false,
                       showFlagMain: true,
                       alignLeft: false,
                       showFlag: true,
                       showFlagDialog: true,
                     ),


                     // prefixText: controller.countryCode.value,
                   );
                 }),

                  SizedBox(
                    height: 2.h,
                  ),
                  addText('About Me', getSmallTextFontSIze(),
                      colorConstants.black, FontWeight.bold),
                  const SizedBox(
                    height: 5,
                  ),
                  Container(
                    width: 80.w,
                    height: 12.h,
                    decoration: BoxDecoration(
                        color: colorConstants.white,
                        // boxShadow: [getDeepBoxShadow()],
                        border: Border.all(color: colorConstants.lightGrey),
                        borderRadius: getBorderRadius()),
                    child: TextFormField(
                      maxLines: 3,
                      keyboardType: TextInputType.multiline,
                      controller: controller.aboutMeController,
                      textInputAction: TextInputAction.newline,
                      style: TextStyle(fontSize: getNormalTextFontSIze()),
                      decoration: InputDecoration(
                          hintText: 'Comment'.tr,
                          hintStyle: TextStyle(
                              fontSize: getNormalTextFontSIze(),
                              color: colorConstants.greyTextColor),
                          contentPadding:
                              const EdgeInsets.fromLTRB(20, 15, 10, 15),
                          border: InputBorder.none),
                    ),
                  ),
                  SizedBox(
                    height: 2.h,
                  ),

                  SizedBox(
                    height: 2.h,
                  ),
                  Obx(
                    () => controller.isUpdating.value
                        ? Align(
                            alignment: Alignment.center,
                            child: getLoader(),
                          )
                        : GestureDetector(
                            onTap: () {
                              if (controller.nameController.text
                                  .trim()
                                  .isEmpty) {
                                showSnackbar(context, 'Please enter name');
                              } else if (controller.phoneController.text
                                  .trim()
                                  .isEmpty) {
                                showSnackbar(context, 'Please enter phone');
                              }
                              else if (controller.phoneController.text.length < 7 || controller.phoneController.text.length > 15) {
                                return  showSnackbar(context, 'Number must be between 7 and 15');
                              }
                              else {
                                controller.updateProfile(context);
                              }
                            },
                            child: getSolidButton(90.w, 'SAVE'),
                          ),
                  ),
                  SizedBox(
                    height: 2.h,
                  ),
                  // GestureDetector(
                  //   onTap: (){
                  //     Get.toNamed(Routes.ResetPassword);
                  //   },
                  //   child: getSolidButton(90.w, 'PASSWORD CHANGE'),
                  // ),
                  // SizedBox(height: 2.h,),
                ],
              ),
            ))
          ],
        ),
      ),
    );
  }

  void _showPicker(context) {
    showModalBottomSheet(
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
              topRight: Radius.circular(20), topLeft: Radius.circular(20)),
        ),
        context: context,
        builder: (BuildContext bc) {
          return SafeArea(
              child: Wrap(
            children: <Widget>[
              const SizedBox(
                height: 20,
              ),
              ListTile(
                  leading: const Icon(
                    Icons.photo_library,
                    color: colorConstants.buttonColor,
                  ),
                  title: addText("Photo Library", getNormalTextFontSIze(),
                      colorConstants.greyTextColor, FontWeight.w500),
                  onTap: () {
                    controller.imgFromGallery();
                    Navigator.of(context).pop();
                  }),
              ListTile(
                leading: const Icon(Icons.photo_camera,
                    color: colorConstants.buttonColor),
                title: addText("Camera", getNormalTextFontSIze(),
                    colorConstants.greyTextColor, FontWeight.w500),
                onTap: () {
                  controller.imgFromCamera();
                  Navigator.of(context).pop();
                },
              ),
            ],
          ));
        });
  }
}
