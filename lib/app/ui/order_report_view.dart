import 'package:file_saver/file_saver.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:odda/app/controller/order_report_controller.dart';
import 'package:odda/common/color_constants.dart';
import 'package:odda/common/header.dart';
import 'package:odda/common/utils.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

import '../../common/preferences.dart';

class OrderReportView extends GetView<OrderReportController> {
  const OrderReportView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: colorConstants.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: [
              AppHeader(title: controller.heading.value),
              const Spacer(),
              addText('Select Start Date', getHeadingTextFontSIze(),
                  colorConstants.black, FontWeight.w600),
              SizedBox(height: 1.h),
              GestureDetector(
                onTap: () {
                  controller.selectDate(context, true);
                },
                child: Obx(() => addText(
                    controller.startDate.value,
                    getHeadingTextFontSIze(),
                    colorConstants.greyTextColor,
                    FontWeight.normal)),
              ),
              const Divider(
                color: colorConstants.primaryColor,
              ),
              SizedBox(height: 2.h),
              addText('Select End Date', getHeadingTextFontSIze(),
                  colorConstants.black, FontWeight.w600),
              SizedBox(height: 1.h),
              GestureDetector(
                onTap: () {
                  if (controller.startDate.value != 'Start Date') {
                    controller.selectDate(context, false);
                  }
                },
                child: Obx(() => addText(
                    controller.endDate.value,
                    getHeadingTextFontSIze(),
                    colorConstants.greyTextColor,
                    FontWeight.normal)),
              ),
              const Divider(
                color: colorConstants.primaryColor,
              ),
              SizedBox(height: 3.h),
              Obx(() => controller.downloading.value
                  ? const CircularProgressIndicator()
                  : GestureDetector(
                      onTap: () async {
                        if (controller.startDate.value == 'Start Date') {
                          showSnackbar(context, 'Please select start date');
                        } else if (controller.endDate.value == 'End Date') {
                          showSnackbar(context, 'Please select end date');
                        } else {
                          controller.downloading.value = true;
                          
                          // CORRECTED: Use fileExtension instead of ext
                          await FileSaver.instance.saveAs(
                            name: "order_report_${controller.startDate.value}_to_${controller.endDate.value}",
                            link: LinkDetails(
                              link: 'https://oddaapp.com/appadmin/api/user/downloadOrderReport?user_id=${getValue(SharedPref.userId)}&from=${controller.startDate.value}&to=${controller.endDate.value}'
                            ),
                            fileExtension: "xlsx",  // Changed from 'ext' to 'fileExtension'
                            mimeType: MimeType.microsoftExcel
                          );
                          
                          showSnackbar(context, 'File Downloaded Successfully');
                          controller.downloading.value = false;
                        }
                      },
                      child: getSolidButton(90.w, 'Download Report'),
                    )),
              const Spacer(),
            ],
          ),
        ),
      ),
    );
  }
}