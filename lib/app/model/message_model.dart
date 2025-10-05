// To parse this JSON data, do
//
//     final messageModel = messageModelFromJson(jsonString);

import 'dart:convert';

MessageModel messageModelFromJson(String str) => MessageModel.fromJson(json.decode(str));

String messageModelToJson(MessageModel data) => json.encode(data.toJson());

class MessageModel {
  MessageModel({
    required this.status,
    required this.msg,
    required this.data,
  });

  bool status;
  String msg;
  List<MessageDatum> data;

  factory MessageModel.fromJson(Map<String, dynamic> json) => MessageModel(
    status: json["status"],
    msg: json["msg"],
    data: List<MessageDatum>.from(json["data"].map((x) => MessageDatum.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "msg": msg,
    "data": List<dynamic>.from(data.map((x) => x.toJson())),
  };
}

class MessageDatum {
  MessageDatum({
    this.id,
    this.userId,
    this.toUserId,
    this.message,
    this.unreadMsgs,
    this.status,
    this.deletedAt,
    this.createdAt,
    required this.updatedAt,
    required this.toUser,
  });

  dynamic id;
  dynamic userId;
  dynamic toUserId;
  dynamic message;
  dynamic status;
  dynamic unreadMsgs;
  dynamic deletedAt;
  dynamic createdAt;
  DateTime updatedAt;
  ToUser toUser;

  factory MessageDatum.fromJson(Map<String, dynamic> json) => MessageDatum(
    id: json["id"],
    userId: json["user_id"],
    toUserId: json["to_user_id"],
    message: json["message"],
    status: json["status"],
    unreadMsgs: json["unread_msgs"],
    deletedAt: json["deleted_at"],
    createdAt: json["created_at"],
    updatedAt: DateTime.parse(json["updated_at"]),
    toUser: ToUser.fromJson(json["to_user"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "user_id": userId,
    "to_user_id": toUserId,
    "message": message,
    "status": status,
    "unread_msgs": unreadMsgs,
    "deleted_at": deletedAt,
    "created_at": createdAt,
    "updated_at": updatedAt.toIso8601String(),
    "to_user": toUser.toJson(),
  };
}

class ToUser {
  ToUser({
    required this.id,
    required this.name,
    required this.image,
  });

  int id;
  String name;
  String image;

  factory ToUser.fromJson(Map<String, dynamic> json) => ToUser(
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
