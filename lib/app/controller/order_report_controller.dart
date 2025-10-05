import 'dart:io';

import 'package:dio/dio.dart';
import 'package:file_saver/file_saver.dart';
import 'package:file_utils/file_utils.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:odda/common/utils.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

class OrderReportController extends GetxController {
  final heading = 'My Order Report'.obs;
  final startDate = 'Start Date'.obs;
  final endDate = 'End Date'.obs;
  final firstDate = DateTime(2015, 8).obs;

  Future<void> selectDate(BuildContext context, bool isStartDate) async {
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: firstDate.value,
        lastDate: DateTime.now());
    if (picked != null) {
      if (isStartDate) {
        startDate.value = DateFormat('yyyy-MM-dd').format(picked);
        firstDate.value = picked;
      } else {
        endDate.value = DateFormat('yyyy-MM-dd').format(picked);
      }
    }
  }

  final downloading = false.obs;
  var progress = "";
  var path = "No Data";
  var platformVersion = "Unknown";
  late Directory externalDir;

  String convertCurrentDateTimeToString() {
    String formattedDateTime =
        DateFormat('yyyyMMdd_kkmmss').format(DateTime.now()).toString();
    return formattedDateTime;
  }

  Future<void> downloadFile(String userId, String startDate, String endDate,
      BuildContext context) async {
    Dio dio = Dio();

    final status = await Permission.storage.request();
    if (status.isGranted) {
      String dirloc = "";
      if (GetPlatform.isAndroid) {
        dirloc = "/sdcard/download/";
      } else {
        dirloc = (await getApplicationDocumentsDirectory()).path;
      }

      try {
        FileUtils.mkdir([dirloc]);

        await dio.download(
            'https://oddaapp.com/appadmin/api/user/downloadOrderReport?user_id=$userId&from=$startDate&to$endDate',
            "$dirloc${convertCurrentDateTimeToString()}.xlsx",
            onReceiveProgress: (receivedBytes, totalBytes) {
          if (kDebugMode) {
            print('here 1');
          }
          downloading.value = true;
          progress =
              "${((receivedBytes / totalBytes) * 100).toStringAsFixed(0)}%";

          if (kDebugMode) {
            print(progress);
          }
          if (kDebugMode) {
            print('here 2');
          }
        });
      } catch (e) {
        if (kDebugMode) {
          print('catch catch catch');
          print(e);
        }
      }
      downloading.value = false;
      progress = "Download Completed.";
      path = "$dirloc${convertCurrentDateTimeToString()}.xlxs";

      showSnackbar(context, 'File Downloaded to $path');
      if (kDebugMode) {
        print(path);
        print('here give alert-->completed');
      }
    } else {
      progress = "Permission Denied!";
    }
  }

}
