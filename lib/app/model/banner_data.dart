// To parse this JSON data, do
//
//     final bannerData = bannerDataFromJson(jsonString);

import 'dart:convert';

BannerData bannerDataFromJson(String str) => BannerData.fromJson(json.decode(str));

String bannerDataToJson(BannerData data) => json.encode(data.toJson());

class BannerData {
  BannerData({
    required this.status,
    required this.msg,
    required this.hasNewNotification,
    required this.data,
  });

  bool status;
  String msg;
  dynamic hasNewNotification;
  List<BannerDatum> data;

  factory BannerData.fromJson(Map<String, dynamic> json) => BannerData(
    status: json["status"],
    msg: json["msg"],
    hasNewNotification: json["hasNewNotification"],
    data: List<BannerDatum>.from(json["data"].map((x) => BannerDatum.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "msg": msg,
    "hasNewNotification": hasNewNotification,
    "data": List<dynamic>.from(data.map((x) => x.toJson())),
  };
}

class BannerDatum {
  BannerDatum({
    required this.id,
    required this.image,
    required this.createdAt,
    required this.updatedAt,
    required this.has_product,
    this.is_banner,
  });

  int id;
  dynamic image;
  dynamic createdAt;
  dynamic updatedAt;
  dynamic has_product;
  bool? is_banner;

  factory BannerDatum.fromJson(Map<String, dynamic> json) => BannerDatum(
    id: json["id"],
    image: json["image"],
    is_banner: json["is_banner"],
    createdAt: json["created_at"],
    updatedAt: json["updated_at"],
    has_product: json["has_product"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "image": image,
    "created_at": createdAt,
    "is_banner": is_banner,
    "updated_at": updatedAt,
    "has_product": has_product,
  };
}
