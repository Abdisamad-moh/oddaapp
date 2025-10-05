// To parse this JSON data, do
//
//     final orderData = orderDataFromJson(jsonString);

import 'dart:convert';

OrderData orderDataFromJson(String str) => OrderData.fromJson(json.decode(str));

String orderDataToJson(OrderData data) => json.encode(data.toJson());

class OrderData {
  OrderData({
    required this.status,
    required this.msg,
    required this.data,
  });

  bool status;
  String msg;
  List<OrderDatum> data;

  factory OrderData.fromJson(Map<String, dynamic> json) => OrderData(
    status: json["status"],
    msg: json["msg"],
    data: List<OrderDatum>.from(json["data"].map((x) => OrderDatum.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "msg": msg,
    "data": List<dynamic>.from(data.map((x) => x.toJson())),
  };
}

class OrderDatum {
  OrderDatum({
    required this.id,
    required this.orderId,
    required this.productId,
    required this.quantity,
    required this.total,
    required this.status,
    required this.canCancel,
    required this.createdAt,
    required this.updatedAt,
    required this.product,
    required this.order,

  });

  int id;
  dynamic orderId;
  dynamic productId;
  dynamic quantity;
  dynamic total;
  dynamic status;
  bool canCancel;
  DateTime createdAt;
  dynamic updatedAt;
  Product product;
  Order order;

  factory OrderDatum.fromJson(Map<String, dynamic> json) => OrderDatum(
    id: json["id"],
    orderId: json["order_id"],
    productId: json["product_id"],
    quantity: json["quantity"],
    total: json["total"],
    status: json["status"],
    canCancel: json["can_cancel"],
    createdAt: DateTime.parse(json["created_at"]),
    updatedAt: json["updated_at"],
    product: Product.fromJson(json["product"]),
    order: Order.fromJson(json["order"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "order_id": orderId,
    "product_id": productId,
    "quantity": quantity,
    "total": total,
    "status": status,
    "can_cancel": canCancel,
    "created_at": createdAt.toIso8601String(),
    "updated_at": updatedAt,
    "product": product.toJson(),
    "order": order.toJson(),
  };
}

class Order {
  Order({
    required this.id,
    required this.deliveryDate,
    required this.orderAddress,
  });

  int id;
  dynamic deliveryDate;
  OrderAddress orderAddress;

  factory Order.fromJson(Map<String, dynamic> json) => Order(
    id: json["id"],
    deliveryDate: json["delivery_date"],
    orderAddress: OrderAddress.fromJson(json["order_address"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "delivery_date": deliveryDate,
    "order_address": orderAddress.toJson(),
  };
}

class OrderAddress {
  OrderAddress({
    required this.id,
    required this.orderId,
    required this.addressType,
    required this.mobileNo,
    required this.city,
    required this.state,
    required this.pincode,
    required this.lat,
    required this.lng,
    required this.address,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
  });

  int id;
  dynamic orderId;
  dynamic addressType;
  dynamic mobileNo;
  dynamic city;
  dynamic state;
  dynamic pincode;
  dynamic lat;
  dynamic lng;
  dynamic address;
  dynamic status;
  dynamic createdAt;
  dynamic updatedAt;

  factory OrderAddress.fromJson(Map<String, dynamic> json) => OrderAddress(
    id: json["id"],
    orderId: json["order_id"],
    addressType: json["address_type"],
    mobileNo: json["mobile_no"],
    city: json["city"],
    state: json["state"],
    pincode: json["pincode"],
    lat: json["lat"],
    lng: json["lng"],
    address: json["address"],
    status: json["status"],
    createdAt: json["created_at"],
    updatedAt: json["updated_at"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "order_id": orderId,
    "address_type": addressType,
    "mobile_no": mobileNo,
    "city": city,
    "state": state,
    "pincode": pincode,
    "lat": lat,
    "lng": lng,
    "address": address,
    "status": status,
    "created_at": createdAt.toIso8601String(),
    "updated_at": updatedAt.toIso8601String(),
  };
}

class Product {
  Product({
    required this.id,
    required this.name,
    required this.vendor,
    required this.productImages,
  });

  int? id;
  dynamic name;
  dynamic vendor;
  List<ProductImage> productImages;

  factory Product.fromJson(Map<String, dynamic> json) => Product(
    id: json["id"],
    name: json["name"],
    vendor: json["vendor"],
    productImages:json["product_images"] == null ? []: List<ProductImage>.from(json["product_images"].map((x) => ProductImage.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "vendor": vendor,
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
