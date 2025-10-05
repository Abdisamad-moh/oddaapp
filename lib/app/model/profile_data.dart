// To parse this JSON data, do
//
//     final profileData = profileDataFromJson(jsonString);

import 'dart:convert';

ProfileData profileDataFromJson(String str) => ProfileData.fromJson(json.decode(str));

String profileDataToJson(ProfileData data) => json.encode(data.toJson());

class ProfileData {
  ProfileData({
    required this.status,
    required this.msg,
    required this.data,
  });

  bool status;
  String msg;
  ProfileDatum data;

  factory ProfileData.fromJson(Map<String, dynamic> json) => ProfileData(
    status: json["status"],
    msg: json["msg"],
    data: ProfileDatum.fromJson(json["data"]),
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "msg": msg,
    "data": data.toJson(),
  };
}

class ProfileDatum {
  ProfileDatum({
    this.id,
    this.name,
    this.email,
    this.countryCode,
    this.mobileNo,
    this.image,
    this.emailVerifiedAt,
    this.countryId,
    this.stateId,
    this.address,
    this.cityId,
    this.about,
    this.rating,
    this.socialId,
    this.loginType,
    this.shippingInfo,
    this.status,
    this.createdAt,
    this.updatedAt,
    this.totalReviews,
  });

  dynamic id;
  dynamic name;
  dynamic email;
  dynamic mobileNo;
  dynamic countryCode;
  dynamic image;
  dynamic emailVerifiedAt;
  dynamic countryId;
  dynamic stateId;
  dynamic address;
  dynamic cityId;
  dynamic about;
  dynamic rating;
  dynamic socialId;
  dynamic loginType;
  dynamic shippingInfo;
  dynamic status;
  dynamic createdAt;
  dynamic updatedAt;
  dynamic totalReviews;

  factory ProfileDatum.fromJson(Map<String, dynamic> json) => ProfileDatum(
    id: json["id"],
    name: json["name"],
    email: json["email"],
    mobileNo: json["mobile_no"],
    countryCode: json["country_code"],
    image: json["image"],
    emailVerifiedAt: json["email_verified_at"],
    countryId: json["country_id"],
    stateId: json["state_id"],
    address: json["address"],
    cityId: json["city_id"],
    about: json["about"],
    rating: json["rating"],
    socialId: json["social_id"],
    loginType: json["login_type"],
    shippingInfo: json["shipping_info"],
    status: json["status"],
    createdAt: json["created_at"],
    updatedAt: json["updated_at"],
    totalReviews: json["total_reviews"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "email": email,
    "mobile_no": mobileNo,
    "country_code": countryCode,
    "image": image,
    "email_verified_at": emailVerifiedAt,
    "country_id": countryId,
    "state_id": stateId,
    "address": address,
    "city_id": cityId,
    "about": about,
    "rating": rating,
    "social_id": socialId,
    "login_type": loginType,
    "shipping_info": shippingInfo,
    "status": status,
    "created_at": createdAt,
    "updated_at": updatedAt,
    "total_reviews": totalReviews,
  };
}
