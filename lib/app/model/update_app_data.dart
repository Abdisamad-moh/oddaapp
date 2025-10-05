// To parse this JSON data, do
//
//     final updateAppData = updateAppDataFromJson(jsonString);

import 'dart:convert';

UpdateAppData updateAppDataFromJson(String str) => UpdateAppData.fromJson(json.decode(str));

String updateAppDataToJson(UpdateAppData data) => json.encode(data.toJson());

class UpdateAppData {
  bool? status;
  Data? data;

  UpdateAppData({
    this.status,
    this.data,
  });

  factory UpdateAppData.fromJson(Map<String, dynamic> json) => UpdateAppData(
    status: json["status"],
    data: json["data"] == null ? null : Data.fromJson(json["data"]),
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "data": data?.toJson(),
  };
}

class Data {
  String? androidVersion;
  String? iosVersion;
  String? playStoreUrl;
  String? appStoreUrl;

  Data({
    this.androidVersion,
    this.iosVersion,
    this.playStoreUrl,
    this.appStoreUrl,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    androidVersion: json["android_version"],
    iosVersion: json["ios_version"],
    playStoreUrl: json["android_store_url"],
    appStoreUrl: json["ios_store_url"],
  );

  Map<String, dynamic> toJson() => {
    "android_version": androidVersion,
    "ios_version": iosVersion,
    "android_store_url": playStoreUrl,
    "ios_store_url": appStoreUrl,
  };
}
