import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:get/get_utils/get_utils.dart';
import 'package:odda/app/controller/job_applicant_controller.dart';
import 'package:odda/app/model/job_applicants_model.dart';
import 'package:odda/common/color_constants.dart';
import 'package:odda/common/header.dart';
import 'package:odda/common/preferences.dart';
import 'package:odda/common/utils.dart';
import 'package:posthog_flutter/posthog_flutter.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class JobApplicants extends GetView<JobApplicantsController> {
  const JobApplicants({super.key});

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
              child: AppHeader(title: 'Locum'),
            ),
            SizedBox(
              height: 4.h,
            ),

            //Sales Representative 2. Tele Marketer
            Container(
              alignment: Alignment.centerLeft,
              height: 4.h,
              child: ListView.builder(
                  itemCount: controller.jobTypes.length,
                  scrollDirection: Axis.horizontal,
                  shrinkWrap: true,

                  itemBuilder: (context, int index) {
                    return Obx(() {
                      return GestureDetector(
                        onTap: () {
                          controller.selectedJobType.value = index;
                          controller.getJobApplicants(); // api call
                        },
                        child: Container(
                          decoration: BoxDecoration(
                              boxShadow: [getDeepBoxShadow()],
                              color: controller.selectedJobType == index
                                  ? colorConstants.buttonColor
                                  : colorConstants.white,
                              borderRadius: getCurvedBorderRadius()),
                          child: Center(
                            child: addAlignedText(
                                '${controller.jobTypes[index]}',
                                getNormalTextFontSIze(),
                                controller.selectedJobType == index
                                    ? colorConstants.white
                                    : colorConstants.black,
                                FontWeight.w600)
                                .marginSymmetric(
                                horizontal: 16.sp, vertical: 10.sp),
                          ),
                        ).marginOnly(left: index==0?0:14.sp),
                      );
                    });
                  }),
            ).marginOnly(bottom: 16.sp, left: 16.sp, right: 16.sp),

            Expanded(
              child: Obx(() {
                return controller.isLoading.value ? buildLoader() :
                controller.jobApplicantsList.isEmpty ? Center(
                    child: addText('Nothing in your job Applicants',
                        getNormalTextFontSIze(), colorConstants.black,
                        FontWeight.w600))
                    : ListView.builder(
                    physics: const BouncingScrollPhysics(),
                    itemCount: controller.jobApplicantsList.length,
                    shrinkWrap: true,
                    itemBuilder: (context, int index) {
                      return build_job_applicants_list_view(
                          controller.jobApplicantsList[index]);
                    });
              }),
            )

          ],
        ),
      ),
    );
  }

  Widget build_job_applicants_list_view(JobApplicantsDatum jobApplicantsList) {
    return Container(
      decoration: BoxDecoration(
          boxShadow: [getDeepBoxShadow()],
          color: colorConstants.white,
          borderRadius: getCurvedBorderRadius()),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    text_view('Name: ${jobApplicantsList.name}'),
                    text_view('Position: ${jobApplicantsList.position}'),
                    text_view('Contact No.: ${jobApplicantsList
                        .countryCode} ${jobApplicantsList.mobileNo}'),
                    text_view('Experience: ${jobApplicantsList.experience}'),
                    download_cv_button(() async { // button
                      controller.launchUrl('${jobApplicantsList.resume}');
                      await Posthog().capture(eventName: 'download_cv',properties: {
                        'user_id': getValue(SharedPref.userId),
                        'user_name': getValue(SharedPref.userName),
                        'mobile_no': getValue(SharedPref.mobileNo),
                        'download_cv_of': jobApplicantsList.name.toString()
                      });

                      // controller.launchURL('https://www.google.com');

                      // String url = '${jobApplicantsList.resume}';
                      // final Uri _url = Uri.parse('${jobApplicantsList.resume}');
                      // print("certo: $url");
                      // print("certo: $_url");
                      //
                      // if (Platform.isIOS) {
                      //   if (await canLaunch(url)) {
                      //     await launch(url);
                      //   } else {
                      //     throw 'Could not launch $url';
                      //   }
                      // } else {
                      //   if (!await launchUrl(_url)) {
                      //     throw Exception('Could not launch $_url');
                      //   }
                      // }
                    }
                    )

                  ],
                ).paddingAll(14.sp),
              ),
            ],
          )
        ],
      ),
    ).marginOnly(left: 16.sp, right: 16.sp, bottom: 16.sp);
  }

  Column text_view(String text) {
    return Column(
      children: [
        addText(text, getNormalTextFontSIze(),
            colorConstants.black, FontWeight.bold),
        const SizedBox(
          height: 5,
        ),
      ],
    );
  }

  GestureDetector download_cv_button(void Function()? onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Center(
        child: Container(
          // padding: const EdgeInsets.symmetric(vertical: 15),
          // width: width,
          decoration: BoxDecoration(
            // color: colorConstants.buttonColor,
            gradient: getButtonGradient(),
            borderRadius: getBorderRadiusCircular(),
          ),
          child: addAlignedText(
              'Download CV',
              getNormalTextFontSIze(),
              colorConstants.white,
              FontWeight.w600)
              .marginSymmetric(
              horizontal: 20.sp, vertical: 10.sp),
        ),
      ),
    );
  }
}


/*Expanded(child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: ListView(
                physics: const BouncingScrollPhysics(),
                children: [

                  addText('Name', getSmallTextFontSIze(), colorConstants.black,
                      FontWeight.bold),
                  const SizedBox(height: 5,),
                  addEditText(controller.nameController, 'Name'),

                  SizedBox(height: 2.h,),
                  addText('Phone Number', getSmallTextFontSIze(),
                      colorConstants.black, FontWeight.bold),
                  const SizedBox(height: 5,),
                  addNumberRegisterEditText(
                    controller.phoneController, 'Phone Number',
                    inputFormatter: [FilteringTextInputFormatter.digitsOnly],
                    leading: CountryCodePicker(
                      flagWidth: 20,
                      onChanged: (CountryCode? code) =>
                          controller.onCountryCodeChanged(code),
                      initialSelection: controller.countryCodeFromApi.value
                          .toString() ?? "+254",
                      favorite: const ['Kenya', '254', 'Somalia', '+252'],
                      showCountryOnly: false,
                      showFlagMain: true,
                      alignLeft: false,
                      showFlag: true,
                      showFlagDialog: true,
                    ),),

                  SizedBox(height: 2.h,),
                  addText(
                      'Position', getSmallTextFontSIze(), colorConstants.black,
                      FontWeight.bold),
                  const SizedBox(height: 5,),
                  addEditText(controller.positionController, 'Position'),

                  SizedBox(height: 2.h,),
                  addText('Experience(Year)', getSmallTextFontSIze(),
                      colorConstants.black, FontWeight.bold),
                  const SizedBox(height: 5,),
                  addEditText(
                      controller.yrExpController, 'Years of Experience'),

                  SizedBox(height: 2.h,),
                  addText('Upload CV ', getSmallTextFontSIze(),
                      colorConstants.black, FontWeight.bold),

                  const SizedBox(height: 5,),
                  GestureDetector(
                    onTap: () {
                      FocusScope.of(context).unfocus();
                      controller.uploadCv(context);
                    },
                    child: addEditText(
                        controller.uploadController, 'Upload CV (Pdf)',
                        trailing: Icon(Icons.upload_file_outlined,
                            color: colorConstants.buttonColor),
                        enabled: false),
                  ),

                  SizedBox(height: 2.h,),
                  Obx(() =>
                  controller.isLoading.value ? Center(
                    child: SizedBox(
                      width: 30, height: 30,
                      child: getLoader(),
                    ),
                  ) : GestureDetector(
                    onTap: () {
                      if (controller.nameController.text
                          .trim()
                          .isEmpty) {
                        showSnackbar(context, 'Please enter Name');
                      } else if (controller.phoneController.text
                          .trim()
                          .isEmpty) {
                        showSnackbar(context, 'Please enter Contact Number');
                      } else if (controller.positionController.text
                          .trim()
                          .isEmpty) {
                        showSnackbar(context, 'Please enter position');
                      } else if (controller.yrExpController.text
                          .trim()
                          .isEmpty) {
                        showSnackbar(context, 'Please enter Yrs of experience');
                      } else if (controller.uploadController.text
                          .trim()
                          .isEmpty) {
                        showSnackbar(context, 'Please upload cv(pdf)');
                      } else {
                        // controller.contactUsRequest(context);

                        log('${controller.cvPath}');
                        controller.dummyApicall(context);
                      }
                    },
                    child: getSolidButton(90.w, 'SUBMIT'),
                  )),

                  SizedBox(height: 2.h,),


                ],
              ),
            ))*/
