import 'package:data_capture/models/position.dart';
import 'dart:convert';

class CapturedData {
  final Owner owner;
  final String streetNumber;
  final String houseNumber;
  final int numberOfRooms;
  final double weeklyAverageRechargeAmount;
  final Position position;
  final String communityName;
  final String lga;
  final DateTime createdAt;

  CapturedData({
    required this.owner,
    required this.streetNumber,
    required this.houseNumber,
    required this.numberOfRooms,
    required this.weeklyAverageRechargeAmount,
    required this.position,
    required this.communityName,
    required this.lga,
    required this.createdAt,
  });

  factory CapturedData.fromRawJson(String str) =>
      CapturedData.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory CapturedData.fromJson(Map<String, dynamic> json) => CapturedData(
        owner: Owner.fromJson(json["owner"]),
        streetNumber: json["streetNumber"],
        houseNumber: json["houseNumber"],
        numberOfRooms: json["numberOfRooms"],
        weeklyAverageRechargeAmount:
            json["weeklyAverageRechargeAmount"].toDouble(),
        position: Position.fromJson(json["position"]),
        communityName: json["communityName"],
        lga: json["lga"],
        createdAt: DateTime.parse(json["createdAt"]),
      );

  Map<String, dynamic> toJson() => {
        "owner": owner.toJson(),
        "streetNumber": streetNumber,
        "houseNumber": houseNumber,
        "numberOfRooms": numberOfRooms,
        "weeklyAverageRechargeAmount": weeklyAverageRechargeAmount,
        "position": position.toJson(),
        "communityName": communityName,
        "lga": lga,
        "createdAt":
            "${createdAt.year.toString().padLeft(4, '0')}-${createdAt.month.toString().padLeft(2, '0')}-${createdAt.day.toString().padLeft(2, '0')}",
      };
}

class Owner {
  final String name;
  final String phone;

  Owner({
    required this.name,
    required this.phone,
  });

  factory Owner.fromRawJson(String str) => Owner.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Owner.fromJson(Map<String, dynamic> json) => Owner(
        name: json["name"],
        phone: json["phone"],
      );

  Map<String, dynamic> toJson() => {
        "name": name,
        "phone": phone,
      };
}
