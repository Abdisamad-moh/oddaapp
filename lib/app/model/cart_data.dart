// To parse this JSON data, do
//
//     final cartData = cartDataFromJson(jsonString);

import 'dart:convert';

CartData cartDataFromJson(String str) => CartData.fromJson(json.decode(str));

String cartDataToJson(CartData data) => json.encode(data.toJson());

class CartData {
  CartData({
    required this.status,
    required this.msg,
    required this.data,
  });

  bool status;
  String msg;
  List<CartDatum> data;

  factory CartData.fromJson(Map<String, dynamic> json) => CartData(
    status: json["status"],
    msg: json["msg"],
    data: List<CartDatum>.from(json["data"].map((x) => CartDatum.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "msg": msg,
    "data": List<dynamic>.from(data.map((x) => x.toJson())),
  };
}

class CartDatum {
  CartDatum({
    required this.id,
    required this.userId,
    required this.productId,
    required this.quantity,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
    required this.product,
  });

  int id;
  dynamic userId;
  dynamic productId;
  dynamic quantity;
  dynamic status;
  DateTime createdAt;
  DateTime updatedAt;
  Product product;

  factory CartDatum.fromJson(Map<String, dynamic> json) => CartDatum(
    id: json["id"],
    userId: json["user_id"],
    productId: json["product_id"],
    quantity: json["quantity"],
    status: json["status"],
    createdAt: DateTime.parse(json["created_at"]),
    updatedAt: DateTime.parse(json["updated_at"]),
    product: Product.fromJson(json["product"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "user_id": userId,
    "product_id": productId,
    "quantity": quantity,
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
  int productId;
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
