// To parse this JSON data, do
//
//     final orderDetailModel = orderDetailModelFromJson(jsonString);

import 'dart:convert';

OrderDetailModel orderDetailModelFromJson(String str) => OrderDetailModel.fromJson(json.decode(str));

String orderDetailModelToJson(OrderDetailModel data) => json.encode(data.toJson());

class OrderDetailModel {
  OrderDetailModel({
    required this.status,
    required this.msg,
    required this.data,
  });

  bool status;
  String msg;
  OrderDetailData data;

  factory OrderDetailModel.fromJson(Map<String, dynamic> json) => OrderDetailModel(
    status: json["status"],
    msg: json["msg"],
    data: OrderDetailData.fromJson(json["data"]),
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "msg": msg,
    "data": data.toJson(),
  };
}

class OrderDetailData {
  OrderDetailData({
    this.id,
    this.orderId,
    this.productId,
    this.quantity,
    this.total,
    this.status,
    required this.createdAt,
    required this.updatedAt,
    this.currencySymbol,
    this.canCancel,
    required this.product,
    required this.orderItemStatuses,
  });

  dynamic id;
  dynamic orderId;
  dynamic productId;
  dynamic quantity;
  dynamic total;
  dynamic status;
  DateTime createdAt;
  DateTime updatedAt;
  dynamic currencySymbol;
  dynamic canCancel;
  Product product;
  List<OrderItemStatus> orderItemStatuses;

  factory OrderDetailData.fromJson(Map<String, dynamic> json) => OrderDetailData(
    id: json["id"],
    orderId: json["order_id"],
    productId: json["product_id"],
    quantity: json["quantity"],
    total: json["total"],
    status: json["status"],
    createdAt: DateTime.parse(json["created_at"]),
    updatedAt: DateTime.parse(json["updated_at"]),
    currencySymbol: json["currency_symbol"],
    canCancel: json["can_cancel"],
    product: Product.fromJson(json["product"]),
    orderItemStatuses: List<OrderItemStatus>.from(json["order_item_statuses"].map((x) => OrderItemStatus.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "order_id": orderId,
    "product_id": productId,
    "quantity": quantity,
    "total": total,
    "status": status,
    "created_at": createdAt.toIso8601String(),
    "updated_at": updatedAt.toIso8601String(),
    "currency_symbol": currencySymbol,
    "can_cancel": canCancel,
    "product": product.toJson(),
    "order_item_statuses": List<dynamic>.from(orderItemStatuses.map((x) => x.toJson())),
  };
}

class OrderItemStatus {
  OrderItemStatus({
    this.id,
    this.orderItemId,
    this.status,
    this.createdAt,
    this.updatedAt,
    this.deliveryStatus,
  });

  dynamic id;
  dynamic orderItemId;
  dynamic status;
  dynamic createdAt;
  DateTime? updatedAt;
  dynamic deliveryStatus;

  factory OrderItemStatus.fromJson(Map<String, dynamic> json) => OrderItemStatus(
    id: json["id"],
    orderItemId: json["order_item_id"],
    status: json["status"],
    createdAt: json["created_at"],
    updatedAt: DateTime.parse(json["updated_at"]),
    deliveryStatus: json["delivery_status"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "order_item_id": orderItemId,
    "status": status,
    "created_at": createdAt,
    "updated_at": updatedAt?.toIso8601String(),
    "delivery_status": deliveryStatus,
  };
}

class Product {
  Product({
    this.id,
    this.name,
    this.userId,
    this.currencySymbol,
    required this.productImages,
  });

  dynamic id;
  dynamic name;
  dynamic userId;
  dynamic currencySymbol;
  List<ProductImage> productImages;

  factory Product.fromJson(Map<String, dynamic> json) => Product(
    id: json["id"],
    name: json["name"],
    userId: json["user_id"],
    currencySymbol: json["currency_symbol"],
    productImages: List<ProductImage>.from(json["product_images"].map((x) => ProductImage.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "user_id": userId,
    "currency_symbol": currencySymbol,
    "product_images": List<dynamic>.from(productImages.map((x) => x.toJson())),
  };
}

class ProductImage {
  ProductImage({
    this.id,
    this.productId,
    this.name,
  });

  dynamic id;
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
