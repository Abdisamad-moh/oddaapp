// To parse this JSON data, do
//
//     final categoriesData = categoriesDataFromJson(jsonString);

import 'dart:convert';

CategoriesData categoriesDataFromJson(String str) => CategoriesData.fromJson(json.decode(str));

String categoriesDataToJson(CategoriesData data) => json.encode(data.toJson());

class CategoriesData {
  CategoriesData({
    required this.status,
    required this.msg,
    required this.data,
  });

  bool status;
  String msg;
  List<CategoriesDatum> data;

  factory CategoriesData.fromJson(Map<String, dynamic> json) => CategoriesData(
    status: json["status"],
    msg: json["msg"],
    data: List<CategoriesDatum>.from(json["data"].map((x) => CategoriesDatum.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "msg": msg,
    "data": List<dynamic>.from(data.map((x) => x.toJson())),
  };
}

class CategoriesDatum {
  CategoriesDatum({
    required this.id,
    required this.ad_id,
    required this.name,
    required this.image,
    required this.description,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
    required this.subCategory,
  });

  int id;
  int ad_id;
  dynamic name;
  dynamic image;
  dynamic description;
  int status;
  DateTime createdAt;
  DateTime updatedAt;
  List<dynamic> subCategory;

  factory CategoriesDatum.fromJson(Map<String, dynamic> json) => CategoriesDatum(
    id: json["id"],
    ad_id: json["ad_id"],
    name: json["name"],
    image: json["image"],
    description: json["description"],
    status: json["status"],
    createdAt: DateTime.parse(json["created_at"]),
    updatedAt: DateTime.parse(json["updated_at"]),
    subCategory: List<dynamic>.from(json["sub_category"].map((x) => x)),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "ad_id": ad_id,
    "name": name,
    "image": image,
    "description": description,
    "status": status,
    "created_at": createdAt.toIso8601String(),
    "updated_at": updatedAt.toIso8601String(),
    "sub_category": List<dynamic>.from(subCategory.map((x) => x)),
  };
}
