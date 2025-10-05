// To parse this JSON data, do
//
//     final loginData = loginDataFromJson(jsonString);

import 'dart:convert';

LoginData loginDataFromJson(String str) => LoginData.fromJson(json.decode(str));

String loginDataToJson(LoginData data) => json.encode(data.toJson());

class LoginData {
  LoginData({
    required this.status,
    required this.msg,
    required this.otp,
     // this.countryCode
  });

  bool status;
  String msg;
  int otp;
  // dynamic countryCode;

  factory LoginData.fromJson(Map<String, dynamic> json) => LoginData(
    status: json["status"],
    msg: json["msg"],
    otp: json["otp"],
    // countryCode: json['countryCode']
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "msg": msg,
    "otp": otp,
    // "countryCode":countryCode
  };
}
