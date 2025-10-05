// To parse this JSON data, do
//
//     final otpData = otpDataFromJson(jsonString);

import 'dart:convert';

OtpData otpDataFromJson(String str) => OtpData.fromJson(json.decode(str));

String otpDataToJson(OtpData data) => json.encode(data.toJson());

class OtpData {
  OtpData({
    required this.status,
    required this.token,
    required this.data,
  });

  bool status;
  String token;
  OtpDatum data;

  factory OtpData.fromJson(Map<String, dynamic> json) => OtpData(
    status: json["status"],
    token: json["token"],
    data: OtpDatum.fromJson(json["data"]),
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "token": token,
    "data": data.toJson(),
  };
}

class OtpDatum {
  OtpDatum({
    required this.id,
    required this.name,
    required this.email,
    required this.mobileNo,
    required this.image,
    required this.emailVerifiedAt,
    required this.countryId,
    required this.stateId,
    required this.address,
    required this.cityId,
    required this.about,
    required this.rating,
    required this.socialId,
    required this.loginType,
    required this.shippingInfo,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
  });

  int id;
  dynamic name;
  dynamic email;
  dynamic mobileNo;
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
  DateTime createdAt;
  DateTime updatedAt;

  factory OtpDatum.fromJson(Map<String, dynamic> json) => OtpDatum(
    id: json["id"],
    name: json["name"],
    email: json["email"],
    mobileNo: json["mobile_no"],
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
    createdAt: DateTime.parse(json["created_at"]),
    updatedAt: DateTime.parse(json["updated_at"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "email": email,
    "mobile_no": mobileNo,
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
    "created_at": createdAt.toIso8601String(),
    "updated_at": updatedAt.toIso8601String(),
  };
}
