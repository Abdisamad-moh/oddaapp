import 'dart:convert';
import 'dart:developer';

import 'package:country_code_picker/country_code_picker.dart';
import 'package:dio/dio.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:odda/app/model/job_applicants_model.dart';
import 'package:odda/app/repository/job_applicants_repository.dart';
import 'package:odda/common/utils.dart';
import 'package:url_launcher/url_launcher.dart';

class JobApplicantsController extends GetxController {
  JobApplicantsController() { // initialize JobApplicantsRepository
    jobApplicantsRepository = JobApplicantsRepository();
  }

  final isLoading = false.obs;
  final isFetching = false.obs;
  late JobApplicantsRepository jobApplicantsRepository;
  final jobApplicantsList = <JobApplicantsDatum>[].obs;


  RxInt selectedJobType = 0.obs;
  RxList jobTypes = ['All', 'Sales Representative', 'Tele Marketer',].obs;


  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    getJobApplicants();
  }

  void getJobApplicants() async {
    try {
      isLoading.value = true;
      ModelJobApplicants modelJobApplicants = await jobApplicantsRepository.getJobApplicants(selectedJobType==1 ? 101 :selectedJobType==2 ? 102 : 0);
      jobApplicantsList.assignAll(modelJobApplicants.data!);
      if(jobApplicantsList.isNotEmpty){

      }
      isLoading.value = false;
    } catch (e) {
      isLoading.value = false;
      if (e is DioException) {
        if (kDebugMode) {
          print('Upper ===  ${ e.response!.data}');
        }

      }
      else {
        Get.snackbar('', e.toString());
        if (kDebugMode) {
          print('Lower ===  $e');
        }
      }
    }
  }

  Future<void> launchUrl(String url) async {
    if (!await canLaunch(url)) {
      throw Exception('Could not launch $url');
    }
    await launch(url);
    log("launching url::=>$url<=::");
  }

  // launchURL(dynamicUrl) async {
  //
  //   try {
  //     if (await canLaunchUrl(Uri.parse(dynamicUrl))) {
  //       await launchUrl(Uri.parse(dynamicUrl), mode: LaunchMode.platformDefault);
  //     } else {
  //       throw 'Could not launch $dynamicUrl';
  //     }
  //   } catch (e) {
  //     print('Error launching URL: $e');
  //   }
  //
  //
  // }

  // upper code for getting job Applicants list



  // below code form to apply for job
  TextEditingController nameController = TextEditingController();
  TextEditingController positionController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController yrExpController = TextEditingController();
  TextEditingController uploadController = TextEditingController();
  // final isLoading = false.obs;

  final countryCodeFromApi = '+254'.obs;
  int? countryCode ;
  String? countryCodeFromPicker;
  final TextEditingController countryCodePickerController = TextEditingController();
  void onCountryCodeChanged(CountryCode? code) {

    countryCode = int.tryParse(code?.dialCode.toString() ?? '');
    countryCodePickerController.text = code.toString();
    countryCodeFromPicker = code?.dialCode;
    Get.log("countryCode:${countryCodePickerController.text}");
    Get.log("countryCodeValue:$countryCode");
    Get.log("countryCodeFromPicker:$countryCodeFromPicker");
  }

//upload Cv
//   List<String> filePath =[];
  RxString cvPath = ''.obs;
  PlatformFile? pickedFile;
  Future<void> uploadCv(BuildContext context) async {
    cvPath = ''.obs;
    uploadController.clear();
    print('uploadCv ontap');
    FilePickerResult? result;
    result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['pdf']
    );
    // filePath.clear();
    if (result != null) {

      // log("images multiple"+result.files.length.toString());
      for (var element in result.files) {
        // filePath.add(element.path.toString());
        if(element.path!.contains('pdf')) {
          cvPath.value = '${element.path}';
          uploadController.text = cvPath.split('/').last;
        }
        else {
          showSnackbar(context, 'Please select only pdf.');
        }
      }
      log("choose file extension $cvPath");
      log("uploadController text ${uploadController.text}");
    }
  }
}

class PdfPathModel{
  String? path;
  PdfPathModel({this.path});

}