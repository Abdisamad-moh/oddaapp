// To parse this JSON data, do
//
//     final adminAddressData = adminAddressDataFromJson(jsonString);

import 'dart:convert';

AdminAccountData adminAddressDataFromJson(String str) => AdminAccountData.fromJson(json.decode(str));

String adminAddressDataToJson(AdminAccountData data) => json.encode(data.toJson());

class AdminAccountData {
  AdminAccountData({
    required this.status,
    required this.msg,
    required this.data,
  });

  bool status;
  String msg;
  AdminAccountDatum data;

  factory AdminAccountData.fromJson(Map<String, dynamic> json) => AdminAccountData(
    status: json["status"],
    msg: json["msg"],
    data: AdminAccountDatum.fromJson(json["data"]),
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "msg": msg,
    "data": data.toJson(),
  };
}

class AdminAccountDatum {
  AdminAccountDatum({
    required this.id,
    required this.bankName,
    required this.accountNo,
    required this.swiftCode,
  });

  int id;
  String bankName;
  String accountNo;
  String swiftCode;

  factory AdminAccountDatum.fromJson(Map<String, dynamic> json) => AdminAccountDatum(
    id: json["id"],
    bankName: json["bank_name"],
    accountNo: json["account_no"],
    swiftCode: json["swift_code"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "bank_name": bankName,
    "account_no": accountNo,
    "swift_code": swiftCode,
  };
}
