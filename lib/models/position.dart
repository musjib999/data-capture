import 'dart:convert';

Position positionFromJson(String str) => Position.fromJson(json.decode(str));

String positionToJson(Position data) => json.encode(data.toJson());

class Position {
  final double latitude;
  final double longitude;

  Position({
    required this.latitude,
    required this.longitude,
  });

  factory Position.fromJson(Map<String, dynamic> json) => Position(
        latitude: json["latitude"].toDouble(),
        longitude: json["longitude"].toDouble(),
      );

  Map<String, dynamic> toJson() => {
        "latitude": latitude,
        "longitude": longitude,
      };
}
