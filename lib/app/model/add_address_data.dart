// To parse this JSON data, do
//
//     final addAddressData = addAddressDataFromJson(jsonString);

import 'dart:convert';

AddAddressData addAddressDataFromJson(String str) => AddAddressData.fromJson(json.decode(str));

String addAddressDataToJson(AddAddressData data) => json.encode(data.toJson());

class AddAddressData {
  AddAddressData({
    required this.status,
    required this.msg,
    required this.data,
  });

  bool status;
  String msg;
  List<AddAddressDatum> data;

  factory AddAddressData.fromJson(Map<String, dynamic> json) => AddAddressData(
    status: json["status"],
    msg: json["msg"],
    data: List<AddAddressDatum>.from(json["data"].map((x) => AddAddressDatum.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "msg": msg,
    "data": List<dynamic>.from(data.map((x) => x.toJson())),
  };
}

class AddAddressDatum {
  AddAddressDatum({
    required this.id,
    required this.userId,
    required this.addressType,
    required this.address,
    required this.city,
    required this.state,
    required this.mobileNo,
    required this.lat,
    required this.lng,
    required this.pincode,
    required this.isDefault,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
  });

  int id;
  int userId;
  dynamic addressType;
  dynamic address;
  dynamic city;
  dynamic state;
  dynamic mobileNo;
  dynamic lat;
  dynamic lng;
  dynamic pincode;
  dynamic isDefault;
  dynamic status;
  dynamic createdAt;
  dynamic updatedAt;

  factory AddAddressDatum.fromJson(Map<String, dynamic> json) => AddAddressDatum(
    id: json["id"],
    userId: json["user_id"],
    addressType: json["address_type"],
    address: json["address"],
    city: json["city"],
    state: json["state"],
    mobileNo: json["mobile_no"],
    lat: json["lat"],
    lng: json["lng"],
    pincode: json["pincode"],
    isDefault: json["is_default"],
    status: json["status"],
    createdAt: json["created_at"],
    updatedAt: json["updated_at"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "user_id": userId,
    "address_type": addressType,
    "address": address,
    "city": city,
    "state": state,
    "mobile_no": mobileNo,
    "lat": lat,
    "lng": lng,
    "pincode": pincode,
    "is_default": isDefault,
    "status": status,
    "created_at": createdAt,
    "updated_at": updatedAt,
  };
}
