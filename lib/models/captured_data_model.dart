import 'dart:convert';

import 'package:data_capture/models/position.dart';

class CapturedData {
  final Owner owner;
  final String houseType;
  final num grainsPerAnnum;
  final String streetNumber;
  final String houseNumber;
  final int numberOfRooms;
  final double weeklyAverageRechargeAmount;
  final Position position;
  final String communityName;
  final String lga;
  final String sourceOfEnergy;
  final String meansOfTransport;
  final DateTime createdAt;

  CapturedData({
    required this.owner,
    required this.houseType,
    required this.grainsPerAnnum,
    required this.streetNumber,
    required this.houseNumber,
    required this.numberOfRooms,
    required this.weeklyAverageRechargeAmount,
    required this.position,
    required this.communityName,
    required this.lga,
    required this.sourceOfEnergy,
    required this.meansOfTransport,
    required this.createdAt,
  });

  factory CapturedData.fromRawJson(String str) =>
      CapturedData.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory CapturedData.fromJson(Map<String, dynamic> json) => CapturedData(
        owner: Owner.fromJson(json["owner"]),
        houseType: json["houseType"],
        grainsPerAnnum: json["grainsPerAnnum"].toDouble(),
        streetNumber: json["streetNumber"],
        houseNumber: json["houseNumber"],
        numberOfRooms: json["numberOfRooms"],
        weeklyAverageRechargeAmount:
            json["weeklyAverageRechargeAmount"].toDouble(),
        position: Position.fromJson(json["position"]),
        communityName: json["communityName"],
        lga: json["lga"],
        sourceOfEnergy: json["sourceOfEnergy"],
        meansOfTransport: json["meansOfTransport"],
        createdAt: DateTime.parse(json["createdAt"]),
      );

  Map<String, dynamic> toJson() => {
        "owner": owner.toJson(),
        "houseType": houseType,
        "grainsPerAnnum": grainsPerAnnum,
        "streetNumber": streetNumber,
        "houseNumber": houseNumber,
        "numberOfRooms": numberOfRooms,
        "weeklyAverageRechargeAmount": weeklyAverageRechargeAmount,
        "position": position.toJson(),
        "communityName": communityName,
        "lga": lga,
        "sourceOfEnergy": sourceOfEnergy,
        "meansOfTransport": meansOfTransport,
        "createdAt":
            "${createdAt.year.toString().padLeft(4, '0')}-${createdAt.month.toString().padLeft(2, '0')}-${createdAt.day.toString().padLeft(2, '0')}",
      };
}

class FirestoreData {
  final String id;
  final Owner owner;
  final String streetNumber;
  final String houseNumber;
  final int numberOfRooms;
  final double weeklyAverageRechargeAmount;
  final Position position;
  final String communityName;
  final String lga;
  final DateTime createdAt;

  FirestoreData({
    required this.id,
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

  factory FirestoreData.fromRawJson(String str) =>
      FirestoreData.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory FirestoreData.fromJson(Map<String, dynamic> json) => FirestoreData(
        id: json['id'],
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
        "id": id,
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
