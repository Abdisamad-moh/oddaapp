import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:odda/common/color_constants.dart';

import 'package:responsive_sizer/responsive_sizer.dart';

import '../../../common/header.dart';

import '../../../common/utils.dart';
import '../../controller/contact_controller.dart';

class ContactView extends GetView<ContactController>{
  const ContactView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: colorConstants.white,
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 20,),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: AppHeader(title: 'Contact'),
            ),
            SizedBox(height: 4.h,),
            Expanded(child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: ListView(
                physics: const BouncingScrollPhysics(),
                children: [

                  addText('Contact Name', getSmallTextFontSIze(), colorConstants.black, FontWeight.bold),
                  const SizedBox(height: 5,),
                  addEditText(controller.nameController, 'Contact Name'),



                  SizedBox(height: 2.h,),
                  addText('Contact Email', getSmallTextFontSIze(), colorConstants.black, FontWeight.bold),
                  const SizedBox(height: 5,),
                  addEditText(controller.emailController, 'Contact Email'),





                  SizedBox(height: 2.h,),
                  addText('Contact Phone', getSmallTextFontSIze(), colorConstants.black, FontWeight.bold),
                  const SizedBox(height: 5,),
                  addNumberEditText(controller.phoneController, 'Contact Phone'),



                  SizedBox(height: 2.h,),
                  addText('Contact Message', getSmallTextFontSIze(), colorConstants.black, FontWeight.bold),
                  const SizedBox(height: 5,),
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
                      controller: controller.messageController,
                      textInputAction: TextInputAction.newline,
                      style:  TextStyle(fontSize: getNormalTextFontSIze()),
                      decoration: InputDecoration(
                          hintText: 'Contact Message'.tr,
                          hintStyle:TextStyle(fontSize: getNormalTextFontSIze(),color: colorConstants.greyTextColor),
                          contentPadding: const EdgeInsets.fromLTRB(20, 15, 10, 15),
                          border: InputBorder.none),
                    ),
                  ),
                  SizedBox(height: 2.h,),

                  Obx(() => controller.isLoading.value ? Center(
                    child: SizedBox(
                      width: 30,height: 30,
                      child: getLoader(),
                    ),
                  ): GestureDetector(
                    onTap: (){
                      if(controller.nameController.text.trim().isEmpty) {
                        showSnackbar(context, 'Please enter Name');
                      } else if(controller.emailController.text.trim().isEmpty) {
                        showSnackbar(context, 'Please enter Email');
                      } else if(!controller.emailController.text.trim().isValidEmail()) {
                        showSnackbar(context, 'Please enter valid Email');
                      } else if(controller.phoneController.text.trim().isEmpty) {
                        showSnackbar(context, 'Please enter Contact Number');
                      } else if(controller.messageController.text.trim().isEmpty) {
                        showSnackbar(context, 'Please enter message');
                      } else {
                        controller.contactUsRequest(context);
                      }
                    },
                    child: getSolidButton(90.w, 'SUBMIT'),
                  )),
                  SizedBox(height: 2.h,),




                ],
              ),
            ))







          ],
        ),
      ),
    );
  }

}