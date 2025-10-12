// To parse this JSON data, do
//
//     final modelJobTypes = modelJobTypesFromJson(jsonString);

import 'dart:convert';

ModelJobTypes modelJobTypesFromJson(String str) => ModelJobTypes.fromJson(json.decode(str));

String modelJobTypesToJson(ModelJobTypes data) => json.encode(data.toJson());

class ModelJobTypes {
  bool? status;
  String? msg;
  List<JobTypeDatum>? data;
  bool? hasNewNotification;

  ModelJobTypes({
    this.status,
    this.msg,
    this.data,
    this.hasNewNotification,
  });

  factory ModelJobTypes.fromJson(Map<String, dynamic> json) => ModelJobTypes(
        status: json["status"],
        msg: json["msg"],
        data: json["data"] == null
            ? []
            : List<JobTypeDatum>.from(
                json["data"].map((x) => JobTypeDatum.fromJson(x))),
        hasNewNotification: json["hasNewNotification"],
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "msg": msg,
        "data": data == null
            ? []
            : List<dynamic>.from(data!.map((x) => x.toJson())),
        "hasNewNotification": hasNewNotification,
      };
}

class JobTypeDatum {
  int? id;
  String? name;
  DateTime? createdAt;
  DateTime? updatedAt;

  JobTypeDatum({
    this.id,
    this.name,
    this.createdAt,
    this.updatedAt,
  });

  factory JobTypeDatum.fromJson(Map<String, dynamic> json) => JobTypeDatum(
        id: json["id"],
        name: json["name"],
        createdAt: json["created_at"] == null
            ? null
            : DateTime.tryParse(json["created_at"]),
        updatedAt: json["updated_at"] == null
            ? null
            : DateTime.tryParse(json["updated_at"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "created_at": createdAt?.toIso8601String(),
        "updated_at": updatedAt?.toIso8601String(),
      };
}
