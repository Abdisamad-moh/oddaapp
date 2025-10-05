// To parse this JSON data, do
//
//     final wishlistData = wishlistDataFromJson(jsonString);

import 'dart:convert';

WishlistData wishlistDataFromJson(String str) => WishlistData.fromJson(json.decode(str));

String wishlistDataToJson(WishlistData data) => json.encode(data.toJson());

class WishlistData {
  WishlistData({
    required this.status,
    required this.msg,
    required this.data,
  });

  bool status;
  String msg;
  List<WishlistDatum> data;

  factory WishlistData.fromJson(Map<String, dynamic> json) => WishlistData(
    status: json["status"],
    msg: json["msg"],
    data: List<WishlistDatum>.from(json["data"].map((x) => WishlistDatum.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "msg": msg,
    "data": List<dynamic>.from(data.map((x) => x.toJson())),
  };
}

class WishlistDatum {
  WishlistDatum({
    required this.id,
    required this.userId,
    required this.productId,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
    required this.product,
  });

  int id;
  dynamic userId;
  dynamic productId;
  dynamic status;
  DateTime createdAt;
  DateTime updatedAt;
  Product product;

  factory WishlistDatum.fromJson(Map<String, dynamic> json) => WishlistDatum(
    id: json["id"],
    userId: json["user_id"],
    productId: json["product_id"],
    status: json["status"],
    createdAt: DateTime.parse(json["created_at"]),
    updatedAt: DateTime.parse(json["updated_at"]),
    product: Product.fromJson(json["product"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "user_id": userId,
    "product_id": productId,
    "status": status,
    "created_at": createdAt.toIso8601String(),
    "updated_at": updatedAt.toIso8601String(),
    "product": product.toJson(),
  };
}

class Product {
  Product({
    required this.id,
    required this.title,
    required this.name,
    required this.price,
    required this.rating,
    required this.status,
    required this.productImages,
  });

  int id;
  dynamic title;
  dynamic name;
  dynamic price;
  dynamic rating;
  dynamic status;
  List<ProductImage> productImages;

  factory Product.fromJson(Map<String, dynamic> json) => Product(
    id: json["id"],
    title: json["brand_name"],
    name: json["name"],
    price: json["price"],
    rating: json["rating"],
    status: json["status"],
    productImages: List<ProductImage>.from(json["product_images"].map((x) => ProductImage.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "title": title,
    "name": name,
    "price": price,
    "rating": rating,
    "status": status,
    "product_images": List<dynamic>.from(productImages.map((x) => x.toJson())),
  };
}

class ProductImage {
  ProductImage({
    required this.id,
    required this.productId,
    required this.name,
  });

  int id;
  dynamic productId;
  dynamic name;

  factory ProductImage.fromJson(Map<String, dynamic> json) => ProductImage(
    id: json["id"],
    productId: json["product_id"],
    name: json["name"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "product_id": productId,
    "name": name,
  };
}
