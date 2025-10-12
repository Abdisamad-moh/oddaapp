import 'dart:convert';
import 'dart:developer';

import 'package:country_code_picker/country_code_picker.dart';
import 'package:dio/dio.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:odda/app/model/job_applicants_model.dart';
import 'package:odda/app/model/job_type_model.dart';
import 'package:odda/app/repository/job_applicants_repository.dart';
import 'package:odda/app/repository/job_type_repository.dart';
import 'package:odda/common/utils.dart';
import 'package:url_launcher/url_launcher.dart';

class JobApplicantsController extends GetxController {
  JobApplicantsController() {
    jobApplicantsRepository = JobApplicantsRepository();
    jobTypeRepository = JobTypeRepository();
  }

  /// -----------------------
  /// VARIABLES
  /// -----------------------
  final isLoading = false.obs;
  final isFetching = false.obs;

  late JobApplicantsRepository jobApplicantsRepository;
  late JobTypeRepository jobTypeRepository;

  final jobApplicantsList = <JobApplicantsDatum>[].obs;
  final jobTypes = <JobTypeDatum>[].obs;

  RxInt selectedJobTypeIndex = 0
      .obs; // index for UI highlight (the position in the list)
  RxInt selectedJobTypeId = 0.obs; // the actual job type ID to send to API

  /// -----------------------
  /// ON INIT
  /// -----------------------
  @override
  void onInit() {
    super.onInit();
    fetchJobTypes(); // fetch job categories first
  }

  /// -----------------------
  /// FETCH JOB TYPES FROM BACKEND
  /// -----------------------
  Future<void> fetchJobTypes() async {
    try {
      isLoading.value = true;

      final result = await jobTypeRepository.getJobTypes();
      if (result.status == true && result.data != null) {
        jobTypes.value = result.data!;

        // Optionally add an "All" category at the beginning
        jobTypes.insert(
          0,
          JobTypeDatum(id: 0, name: 'All'),
        );

        // Automatically select "All" on first load
        selectedJobTypeId.value = 0;

        // Once loaded, fetch applicants for 'All' or first type
        getJobApplicants();
      } else {
        jobTypes.clear();
      }
    } catch (e) {
      print('Error fetching job types: $e');
      showSnackbar(Get.context!, 'Failed to fetch job categories');
    } finally {
      isLoading.value = false;
    }
  }

  /// -----------------------
  /// FETCH JOB APPLICANTS BASED ON SELECTED JOB TYPE
  /// -----------------------
  void getJobApplicants() async {
    try {
      isLoading.value = true;
      final jobTypeId = selectedJobTypeId.value; // send correct ID to API

      ModelJobApplicants modelJobApplicants =
          await jobApplicantsRepository.getJobApplicants(jobTypeId);

      jobApplicantsList.assignAll(modelJobApplicants.data ?? []);
      isLoading.value = false;
    } catch (e) {
      isLoading.value = false;
      if (e is DioException) {
        if (kDebugMode) print('Error response: ${e.response?.data}');
      } else {
        if (kDebugMode) print('Error: $e');
        showSnackbar(Get.context!, e.toString());
      }
    }
  }

  /// -----------------------
  /// LAUNCH CV URL
  /// -----------------------
  Future<void> launchUrl(String url) async {
    if (!await canLaunch(url)) {
      throw Exception('Could not launch $url');
    }
    await launch(url);
    log("launching url::=>$url<=::");
  }

  /// -----------------------
  /// FORM INPUT CONTROLLERS
  /// -----------------------
  TextEditingController nameController = TextEditingController();
  TextEditingController positionController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController yrExpController = TextEditingController();
  TextEditingController uploadController = TextEditingController();

  final countryCodeFromApi = '+254'.obs;
  int? countryCode;
  String? countryCodeFromPicker;
  final TextEditingController countryCodePickerController =
      TextEditingController();

  void onCountryCodeChanged(CountryCode? code) {
    countryCode = int.tryParse(code?.dialCode.toString() ?? '');
    countryCodePickerController.text = code.toString();
    countryCodeFromPicker = code?.dialCode;
    Get.log("countryCode:${countryCodePickerController.text}");
    Get.log("countryCodeValue:$countryCode");
    Get.log("countryCodeFromPicker:$countryCodeFromPicker");
  }

  /// -----------------------
  /// UPLOAD CV
  /// -----------------------
  RxString cvPath = ''.obs;
  PlatformFile? pickedFile;

  Future<void> uploadCv(BuildContext context) async {
    cvPath = ''.obs;
    uploadController.clear();
    print('uploadCv ontap');
    FilePickerResult? result;
    result = await FilePicker.platform
        .pickFiles(type: FileType.custom, allowedExtensions: ['pdf']);

    if (result != null) {
      for (var element in result.files) {
        if (element.path!.contains('pdf')) {
          cvPath.value = '${element.path}';
          uploadController.text = cvPath.split('/').last;
        } else {
          showSnackbar(context, 'Please select only pdf.');
        }
      }
      log("choose file extension $cvPath");
      log("uploadController text ${uploadController.text}");
    }
  }
}

class PdfPathModel {
  String? path;
  PdfPathModel({this.path});
}
