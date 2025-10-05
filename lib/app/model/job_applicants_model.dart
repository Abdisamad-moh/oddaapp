// To parse this JSON data, do
//
//     final modelJobApplicants = modelJobApplicantsFromJson(jsonString);

import 'dart:convert';

ModelJobApplicants modelJobApplicantsFromJson(String str) => ModelJobApplicants.fromJson(json.decode(str));

String modelJobApplicantsToJson(ModelJobApplicants data) => json.encode(data.toJson());

class ModelJobApplicants {
  bool? status;
  String? msg;
  List<JobApplicantsDatum>? data;
  bool? hasNewNotification;

  ModelJobApplicants({
    this.status,
    this.msg,
    this.data,
    this.hasNewNotification,
  });

  factory ModelJobApplicants.fromJson(Map<String, dynamic> json) => ModelJobApplicants(
    status: json["status"],
    msg: json["msg"],
    data: json["data"] == null ? [] : List<JobApplicantsDatum>.from(json["data"]!.map((x) => JobApplicantsDatum.fromJson(x))),
    hasNewNotification: json["hasNewNotification"],
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "msg": msg,
    "data": data == null ? [] : List<dynamic>.from(data!.map((x) => x.toJson())),
    "hasNewNotification": hasNewNotification,
  };
}

class JobApplicantsDatum {
  int? id;
  String? name;
  String? countryCode;
  String? mobileNo;
  String? email;
  String? position;
  String? experience;
  String? resume;
  int? status;
  dynamic deletedAt;
  DateTime? createdAt;
  DateTime? updatedAt;

  JobApplicantsDatum({
    this.id,
    this.name,
    this.countryCode,
    this.mobileNo,
    this.email,
    this.position,
    this.experience,
    this.resume,
    this.status,
    this.deletedAt,
    this.createdAt,
    this.updatedAt,
  });

  factory JobApplicantsDatum.fromJson(Map<String, dynamic> json) => JobApplicantsDatum(
    id: json["id"],
    name: json["name"],
    countryCode: json["country_code"],
    mobileNo: json["mobile_no"],
    email: json["email"],
    position: json["position"],
    experience: json["experience"],
    resume: json["resume"],
    status: json["status"],
    deletedAt: json["deleted_at"],
    createdAt: json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
    updatedAt: json["updated_at"] == null ? null : DateTime.parse(json["updated_at"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "country_code": countryCode,
    "mobile_no": mobileNo,
    "email": email,
    "position": position,
    "experience": experience,
    "resume": resume,
    "status": status,
    "deleted_at": deletedAt,
    "created_at": createdAt?.toIso8601String(),
    "updated_at": updatedAt?.toIso8601String(),
  };
}
