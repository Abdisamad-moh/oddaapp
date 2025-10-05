import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:intl/intl.dart';
import 'package:odda/common/color_constants.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:shimmer/shimmer.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';

Text addText(String text, double size, Color color, FontWeight fontWeight) {
  return Text(text.tr,
      maxLines: 3,
      style: TextStyle(color: color, fontSize: size, fontWeight: fontWeight));
}

Text addUnderlineText(
    String text, double size, Color color, FontWeight fontWeight) {
  return Text(
    text.tr,
    maxLines: 2,
    style: TextStyle(
        color: color,
        fontSize: size,
        fontWeight: fontWeight,
        decoration: TextDecoration.underline),
  );
}

Widget buildSoldOutIcon() {
  return Container(
    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
    decoration: BoxDecoration(
        color: colorConstants.black.withOpacity(0.4),
        borderRadius: getBorderRadiusCircular()),
    child:
        addAlignedText('SOLD OUT', 10, colorConstants.white, FontWeight.bold),
  );
}

Text addLengthText(
    String text, double size, Color color, FontWeight fontWeight) {
  return Text(text.tr,
      maxLines: 1,
      style: TextStyle(color: color, fontSize: size, fontWeight: fontWeight));
}

Text addAlignedText(
    String text, double size, Color color, FontWeight fontWeight) {
  return Text(
    text.tr,
    textAlign: TextAlign.center,
    maxLines: 3,
    style: TextStyle(
      color: color,
      fontSize: size,
      fontWeight: fontWeight,
    ),
  );
}

Widget addEditText(TextEditingController controller, String hintText,
    {List<TextInputFormatter>? inputFormatter, Widget? trailing,bool? enabled}) {
  return Container(
    width: 90.w,
    decoration: BoxDecoration(
        color: colorConstants.white,
        // boxShadow: [getDeepBoxShadow()],
        border: Border.all(color: colorConstants.lightGrey),
        borderRadius: getBorderRadiusCircular()),
    child: TextFormField(
      inputFormatters: inputFormatter,
      // inputFormatters: [CapitalCaseTextFormatter()],
      keyboardType: TextInputType.text,
      controller: controller,
      textInputAction: TextInputAction.next,
      style: TextStyle(fontSize: getNormalTextFontSIze()),
      enabled: enabled??true,
      decoration: InputDecoration(
          hintText: hintText.tr,
          hintStyle: TextStyle(
              fontSize: getNormalTextFontSIze(),
              color: colorConstants.greyTextColor),
          suffixIcon: trailing,
          contentPadding: const EdgeInsets.fromLTRB(20, 15, 10, 15),
          border: InputBorder.none),
    ),
  );
}

Widget addLimitEditText(
    Size size, TextEditingController controller, var hintText, int limit) {
  return Container(
    decoration: BoxDecoration(
        color: colorConstants.white,
        boxShadow: [getDeepBoxShadow()],
        borderRadius: getBorderRadiusCircular()),
    child: Row(
      children: [
        SizedBox(
          width: size.width * 0.7,
          child: TextFormField(
            inputFormatters: [
              LengthLimitingTextInputFormatter(limit),
              // CapitalCaseTextFormatter()
            ],
            keyboardType: TextInputType.text,
            controller: controller,
            textInputAction: TextInputAction.next,
            style: TextStyle(fontSize: getHeadingTextFontSIze()),
            decoration: InputDecoration(
                hintText: hintText,
                hintStyle: TextStyle(fontSize: getHeadingTextFontSIze()),
                contentPadding: const EdgeInsets.fromLTRB(20, 17, 10, 17),
                border: InputBorder.none),
          ),
        ),
      ],
    ),
  );
}

extension CapExtension on String {
  String capitalizeSentence() {
    // Each sentence becomes an array element
    var sentences = split('@!');
    // Initialize string as empty string
    var output = '';
    // Loop through each sentence
    for (var sen in sentences) {
      // Trim leading and trailing whitespace
      var trimmed = sen.trim();
      // Capitalize first letter of current sentence
      var capitalized = this[0].toUpperCase() + substring(1);
      // Add current sentence to output with a period
      output += capitalized;
    }
    return output;
  }
}

Widget addNumberEditText(TextEditingController controller, String hintText,
    {List<TextInputFormatter>? inputFormatter}) {
  return Container(
    width: 90.w,
    decoration: BoxDecoration(
        color: colorConstants.white,
        // boxShadow: [getDeepBoxShadow()],
        border: Border.all(color: colorConstants.lightGrey),
        borderRadius: getBorderRadiusCircular()),
    child: TextFormField(
      inputFormatters: inputFormatter,
      keyboardType: const TextInputType.numberWithOptions(decimal: true),
      controller: controller,
      textInputAction: TextInputAction.next,
      style: TextStyle(fontSize: getNormalTextFontSIze()),
      decoration: InputDecoration(
          hintText: hintText.tr,
          hintStyle: TextStyle(
              fontSize: getNormalTextFontSIze(),
              color: colorConstants.greyTextColor),
          contentPadding: const EdgeInsets.fromLTRB(20, 15, 10, 15),
          border: InputBorder.none),
    ),
  );
}

Widget addNumberRegisterEditText(
    TextEditingController controller, String hintText,
    {List<TextInputFormatter>? inputFormatter,
    Widget? leading,
    Widget? prefixIcon,
    String? prefixText}) {
  return Padding(
    padding: const EdgeInsets.all(0.0),
    child: Container(
      width: 90.w,
      decoration: BoxDecoration(
        color: colorConstants.white,
        border: Border.all(color: colorConstants.lightGrey),
        borderRadius: getBorderRadiusCircular(),
      ),
      child: Row(
        children: [
          FittedBox(child: leading ?? Container()),
          Flexible(
            child: TextFormField(
              inputFormatters: inputFormatter,
              keyboardType:
                  const TextInputType.numberWithOptions(decimal: true),
              controller: controller,
              textInputAction: TextInputAction.next,
              style: TextStyle(fontSize: getNormalTextFontSIze()),
              decoration: InputDecoration(
                prefixIcon: prefixIcon,
                prefixText: prefixText,
                prefixStyle: const TextStyle(fontSize: 10),
                hintText: hintText.tr,
                hintStyle: TextStyle(
                  fontSize: getNormalTextFontSIze(),
                  color: colorConstants.greyTextColor,
                ),
                // contentPadding:
                // const EdgeInsets.fromLTRB(20, 15, 10, 15),
                border: InputBorder.none,
              ),
            ),
          ),
        ],
      ),
    ),
  );
}

double getSmallTextFontSIze() {
  return 1.4.h;
}

double getSmallestTextFontSIze() {
  return 1.2.h;
}

double getNormalTextFontSIze() {
  return 1.8.h - 1;
}

double getSubheadingTextFontSIze() {
  return 1.9.h;
}

double getHeadingTextFontSIze() {
  return 2.1.h;
}

double getLargeTextFontSIze() {
  return 2.8.h;
}

BoxShadow getBoxShadow() {
  return const BoxShadow(
    color: Colors.black38,
    offset: Offset(
      2.0,
      3.0,
    ),
    blurRadius: 2.0,
    spreadRadius: 0.0,
  );
}

BoxShadow getLightBoxShadow() {
  return const BoxShadow(
    color: Colors.black12,
    offset: Offset(
      2.0,
      3.0,
    ),
    blurRadius: 2.0,
    spreadRadius: 0.0,
  );
}

BoxShadow getDeepBoxShadow() {
  return const BoxShadow(
    color: Colors.black12,
    offset: Offset(
      0.0,
      3.0,
    ),
    blurRadius: 10.0,
    spreadRadius: 0.0,
  );
}

BoxShadow getPurpleBoxShadow() {
  return const BoxShadow(
    color: Color(0xFF6136C1),
    offset: Offset(
      0.0,
      3.0,
    ),
    blurRadius: 10.0,
    spreadRadius: 0.0,
  );
}

BorderRadius getBorderRadius() {
  return BorderRadius.circular(10);
}

BorderRadius getEdgyBorderRadius() {
  return BorderRadius.circular(5);
}

BorderRadius getBorderRadiusCircular() {
  return BorderRadius.circular(100);
}

BorderRadius getCurvedBorderRadius() {
  return BorderRadius.circular(20);
}

Widget verticalDivider() {
  return SizedBox(
      height: getHeadingTextFontSIze(),
      child: const VerticalDivider(color: colorConstants.lightGrey));
}

void showSnackbar(BuildContext context, String message) {
  if (message.contains("Exception:")) {
    message = message.replaceAll("Exception:", "");
  }

  final overlayState = Overlay.of(context);
  if (overlayState != null) {
    showTopSnackBar(
      overlayState,
      CustomSnackBar.info(
        backgroundColor: colorConstants.primaryColor2,
        icon: Container(),
        message: message,
        textStyle: TextStyle(
            color: colorConstants.white,
            fontSize: getNormalTextFontSIze(),
            fontWeight: FontWeight.w600),
      ),
    );
  }
}

void showErrorSnackbar(BuildContext context, String message) {
  if (message.contains("Exception:")) {
    message = message.replaceAll("Exception:", '');
  }

  final overlayState = Overlay.of(context);
  if (overlayState != null) {
    showTopSnackBar(
      overlayState,
      CustomSnackBar.error(
        icon: Container(),
        message: message,
        textStyle: TextStyle(
            color: colorConstants.white,
            fontSize: getHeadingTextFontSIze(),
            fontWeight: FontWeight.w600),
      ),
    );
  }
}

void storeValue(String key, String value) {
  // print("Stored Value $value");
  GetStorage box = GetStorage();
  box.write(key, value);
}

String getValue(String key) {
  GetStorage box = GetStorage();
  var value = box.read(key);
  return value.toString();
}

void deleteValue(String key) {
  GetStorage box = GetStorage();
  box.remove(key);
}

LinearGradient getButtonGradient() {
  return const LinearGradient(
      begin: Alignment.centerLeft,
      end: Alignment.centerRight,
      colors: [
        Color(0xFF0065B0),
        Color(0xFF297CC9),
        Color(0xFF5A97E8),
      ]);
}

LinearGradient getBgGradient() {
  return const LinearGradient(
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
      colors: [
        Color(0xFF5A97E8),
        Color(0xFF297CC9),
        Color(0xFF0065B0),
      ]);
}

Container getSolidButton(double width, String text) {
  return Container(
    padding: const EdgeInsets.symmetric(vertical: 15),
    width: width,
    decoration: BoxDecoration(
      // color: colorConstants.buttonColor,
      gradient: getButtonGradient(),
      borderRadius: getBorderRadiusCircular(),
    ),
    child: addAlignedText(
        text, getNormalTextFontSIze(), colorConstants.white, FontWeight.w600),
  );
}

Container getDisabledButton(double width, String text) {
  return Container(
    padding: const EdgeInsets.symmetric(vertical: 15),
    width: width,
    decoration: BoxDecoration(
        color: colorConstants.greyTextColor,
        borderRadius: getBorderRadiusCircular()),
    child: addAlignedText(
        text, getNormalTextFontSIze(), colorConstants.white, FontWeight.w600),
  );
}

Container getBorderButton(double width, String text) {
  return Container(
    padding: const EdgeInsets.symmetric(vertical: 14),
    width: width,
    decoration: BoxDecoration(
        color: colorConstants.white,
        borderRadius: getBorderRadiusCircular(),
        border: Border.all(color: colorConstants.primaryColor, width: 1.5)),
    child: addAlignedText(text, getNormalTextFontSIze(),
        colorConstants.primaryColor, FontWeight.w600),
  );
}

CircularProgressIndicator getLoader() {
  return const CircularProgressIndicator(
    color: colorConstants.primaryColor2,
  );
}

Widget buildProductLoader() {
  return Shimmer.fromColors(
    baseColor: colorConstants.lightGrey,
    highlightColor: colorConstants.shimmerColor,
    child: GridView.builder(
      shrinkWrap: true,
      physics: const BouncingScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          // crossAxisSpacing: 20,
          // mainAxisSpacing: 20,
          mainAxisExtent: 27.h),
      itemBuilder: (context, index) => GestureDetector(
        onTap: () {},
        child: Container(
          margin: index.isOdd
              ? const EdgeInsets.only(right: 20, left: 10, bottom: 20)
              : const EdgeInsets.only(left: 20, right: 10, bottom: 20),
          decoration: BoxDecoration(
              boxShadow: [getDeepBoxShadow()],
              color: colorConstants.white,
              borderRadius: getCurvedBorderRadius()),
          child: ClipRRect(
            borderRadius: getCurvedBorderRadius(),
            child: Container(),
          ),
        ),
      ),
      itemCount: 20,
    ),
  );
}

Widget buildLoader() {
  return Shimmer.fromColors(
    baseColor: colorConstants.lightGrey,
    highlightColor: colorConstants.shimmerColor,
    child: ListView(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      children: [
        const SizedBox(
          height: 20,
        ),
        Container(
          decoration: BoxDecoration(
              boxShadow: [getDeepBoxShadow()],
              color: colorConstants.white,
              borderRadius: getCurvedBorderRadius()),
          child: ClipRRect(
            borderRadius: getBorderRadiusCircular(),
            child: SizedBox(
              width: 90.w,
              height: 30.w,
            ),
          ),
        ),
        const SizedBox(
          height: 20,
        ),
        Container(
          decoration: BoxDecoration(
              boxShadow: [getDeepBoxShadow()],
              color: colorConstants.white,
              borderRadius: getCurvedBorderRadius()),
          child: ClipRRect(
            borderRadius: getBorderRadiusCircular(),
            child: SizedBox(
              width: 90.w,
              height: 30.w,
            ),
          ),
        ),
        const SizedBox(
          height: 20,
        ),
        Container(
          decoration: BoxDecoration(
              boxShadow: [getDeepBoxShadow()],
              color: colorConstants.white,
              borderRadius: getCurvedBorderRadius()),
          child: ClipRRect(
            borderRadius: getBorderRadiusCircular(),
            child: SizedBox(
              width: 90.w,
              height: 30.w,
            ),
          ),
        ),
        const SizedBox(
          height: 20,
        ),
        Container(
          decoration: BoxDecoration(
              boxShadow: [getDeepBoxShadow()],
              color: colorConstants.white,
              borderRadius: getCurvedBorderRadius()),
          child: ClipRRect(
            borderRadius: getBorderRadiusCircular(),
            child: SizedBox(
              width: 90.w,
              height: 30.w,
            ),
          ),
        ),
        const SizedBox(
          height: 20,
        ),
        Container(
          decoration: BoxDecoration(
              boxShadow: [getDeepBoxShadow()],
              color: colorConstants.white,
              borderRadius: getCurvedBorderRadius()),
          child: ClipRRect(
            borderRadius: getBorderRadiusCircular(),
            child: SizedBox(
              width: 90.w,
              height: 30.w,
            ),
          ),
        ),
        const SizedBox(
          height: 20,
        ),
        Container(
          decoration: BoxDecoration(
              boxShadow: [getDeepBoxShadow()],
              color: colorConstants.white,
              borderRadius: getCurvedBorderRadius()),
          child: ClipRRect(
            borderRadius: getBorderRadiusCircular(),
            child: SizedBox(
              width: 90.w,
              height: 30.w,
            ),
          ),
        ),
        const SizedBox(
          height: 20,
        ),
        Container(
          decoration: BoxDecoration(
              boxShadow: [getDeepBoxShadow()],
              color: colorConstants.white,
              borderRadius: getCurvedBorderRadius()),
          child: ClipRRect(
            borderRadius: getBorderRadiusCircular(),
            child: SizedBox(
              width: 90.w,
              height: 30.w,
            ),
          ),
        ),
      ],
    ),
  );
}

extension EmailValidator on String {
  bool isValidEmail() {
    return RegExp(
            r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$')
        .hasMatch(this);
  }
}

bool validateStructure(String value) {
  String pattern =
      r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{8,}$';
  RegExp regExp = RegExp(pattern);
  return regExp.hasMatch(value);
}

Future<String?> getDeviceId() async {
  try {
    DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
    if (Platform.isAndroid) {
      AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
      return androidInfo.id; // Returns the Android ID
    } else if (Platform.isIOS) {
      IosDeviceInfo iosInfo = await deviceInfo.iosInfo;
      return iosInfo.identifierForVendor; // Returns the vendor identifier for iOS
    }
    return null;
  } catch (e) {
    print('Error getting device ID: $e');
    return null;
  }
}

Future<String?> getDeviceToken() async {
  String? token = await FirebaseMessaging.instance.getToken();
  return token;
}

String getDeviceType() {
  if (Platform.isIOS) {
    return "ios";
  } else {
    return "android";
  }
}

String getTime(String time) {
  DateTime dateTime = DateTime.parse(time);
  // return '${dateTime.hour}:${dateTime.minute}';
  return DateFormat('dd-MM-yyyy hh:mm a').format(dateTime);
}