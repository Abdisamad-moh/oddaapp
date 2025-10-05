// To parse this JSON data, do
//
//     final productDetailData = productDetailDataFromJson(jsonString);

import 'dart:convert';

ProductDetailData productDetailDataFromJson(String str) => ProductDetailData.fromJson(json.decode(str));

String productDetailDataToJson(ProductDetailData data) => json.encode(data.toJson());

class ProductDetailData {
  ProductDetailData({
    required this.status,
    required this.msg,
    required this.data,
  });

  bool status;
  String msg;
  Data data;

  factory ProductDetailData.fromJson(Map<String, dynamic> json) => ProductDetailData(
    status: json["status"],
    msg: json["msg"],
    data: Data.fromJson(json["data"]),
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "msg": msg,
    "data": data.toJson(),
  };
}

class Data {
  Data({
    this.id,
    this.userId,
    this.categoryId,
    this.subCategoryId,
    this.title,
    this.name,
    this.description,
    this.quantity,
    this.price,
    this.rating,
    this.totalSale,
    this.sku,
    this.isFeatured,
    this.completedOrders,
    this.status,
    required this.createdAt,
    required this.updatedAt,
    this.subCategory,
    required this.isWishlisted,
    required this.inCart,
    required this.can_reviewed,
    required this.address,
    this.timeToCreated,
    required this.relatedProducts,
    required this.vendor,
    required this.productImages,
    required this.category,
    required this.review,
    required this.brand_name,
  });

  dynamic id;
  dynamic userId;
  dynamic categoryId;
  dynamic subCategoryId;
  dynamic brand_name;
  dynamic title;
  dynamic name;
  dynamic description;
  dynamic quantity;
  dynamic price;
  dynamic rating;
  dynamic totalSale;
  dynamic sku;
  dynamic isFeatured;
  dynamic completedOrders;
  dynamic status;
  DateTime createdAt;
  DateTime updatedAt;
  dynamic subCategory;
  bool isWishlisted;
  bool inCart;
  bool can_reviewed;
  dynamic address;
  dynamic timeToCreated;
  List<RelatedProduct> relatedProducts;
  Vendor vendor;
  List<ProductImage> productImages;
  Category category;
  List<dynamic> review;

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    id: json["id"],
    userId: json["user_id"],
    categoryId: json["category_id"],
    subCategoryId: json["sub_category_id"],
    title: json["brand_name"],
    name: json["name"],
    description: json["description"],
    brand_name: json["brand_name"],
    quantity: json["quantity"],
    price: json["price"],
    rating: json["rating"],
    totalSale: json["total_sale"],
    sku: json["sku"],
    isFeatured: json["is_featured"],
    completedOrders: json["completed_orders"],
    status: json["status"],
    createdAt: DateTime.parse(json["created_at"]),
    updatedAt: DateTime.parse(json["updated_at"]),
    subCategory: json["sub_category"],
    isWishlisted: json["is_wishlisted"],
    inCart: json["in_cart"],
    can_reviewed: json["can_reviewed"],
    address: json["address"],
    timeToCreated: json["time_to_created"],
    relatedProducts: List<RelatedProduct>.from(json["related_products"].map((x) => RelatedProduct.fromJson(x))),
    vendor: Vendor.fromJson(json["vendor"]),
    productImages: List<ProductImage>.from(json["product_images"].map((x) => ProductImage.fromJson(x))),
    category: Category.fromJson(json["category"]),
    review: List<dynamic>.from(json["review"].map((x) => x)),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "user_id": userId,
    "category_id": categoryId,
    "sub_category_id": subCategoryId,
    "title": title,
    "name": name,
    "description": description,
    "quantity": quantity,
    "price": price,
    "rating": rating,
    "brand_name": brand_name,
    "total_sale": totalSale,
    "sku": sku,
    "is_featured": isFeatured,
    "completed_orders": completedOrders,
    "status": status,
    "created_at": createdAt.toIso8601String(),
    "updated_at": updatedAt.toIso8601String(),
    "sub_category": subCategory.toJson(),
    "is_wishlisted": isWishlisted,
    "in_cart": inCart,
    "can_reviewed": can_reviewed,
    "address": address,
    "time_to_created": timeToCreated,
    "related_products": List<dynamic>.from(relatedProducts.map((x) => x.toJson())),
    "vendor": vendor.toJson(),
    "product_images": List<dynamic>.from(productImages.map((x) => x.toJson())),
    "category": category.toJson(),
    "review": List<dynamic>.from(review.map((x) => x)),
  };
}

class Category {
  Category({
    required this.id,
    this.name,
    this.image,
  });

  int? id;
  dynamic name;
  dynamic image;

  factory Category.fromJson(Map<String, dynamic> json) => Category(
    id: json["id"],
    name: json["name"],
    image: json["image"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "image": image,
  };
}

class ProductImage {
  ProductImage({
    required this.id,
    this.productId,
    this.name,
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

class RelatedProduct {
  RelatedProduct({
    required this.id,
    this.name,
    this.rating,
    this.price,
    required this.productImages,
  });

  int id;
  dynamic name;
  dynamic rating;
  dynamic price;
  List<ProductImage> productImages;

  factory RelatedProduct.fromJson(Map<String, dynamic> json) => RelatedProduct(
    id: json["id"],
    name: json["name"],
    rating: json["rating"],
    price: json["price"],
    productImages: List<ProductImage>.from(json["product_images"].map((x) => ProductImage.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "rating": rating,
    "price": price,
    "product_images": List<dynamic>.from(productImages.map((x) => x.toJson())),
  };
}



class Vendor {
  Vendor({
    required this.id,
    this.name,
    this.email,
    this.mobileNo,
    this.image,
    this.rating,
    required this.createdAt,
    required this.review,
  });

  int id;
  dynamic name;
  dynamic email;
  dynamic mobileNo;
  dynamic image;
  dynamic rating;
  DateTime createdAt;
  List<dynamic> review;

  factory Vendor.fromJson(Map<String, dynamic> json) => Vendor(
    id: json["id"],
    name: json["name"],
    email: json["email"],
    mobileNo: json["mobile_no"],
    image: json["image"],
    rating: json["rating"],
    createdAt: DateTime.parse(json["created_at"]),
    review: List<dynamic>.from(json["review"].map((x) => x)),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "email": email,
    "mobile_no": mobileNo,
    "image": image,
    "rating": rating,
    "created_at": createdAt.toIso8601String(),
    "review": List<dynamic>.from(review.map((x) => x)),
  };
}
