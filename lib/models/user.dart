import 'dart:convert';

class UserData {
  final String name;
  final String email;
  final String userId;

  UserData({
    required this.name,
    required this.email,
    required this.userId,
  });

  factory UserData.fromRawJson(String str) =>
      UserData.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory UserData.fromJson(Map<String, dynamic> json) => UserData(
        name: json["name"],
        email: json["email"],
        userId: json["userId"],
      );

  Map<String, dynamic> toJson() => {
        "name": name,
        "email": email,
        "userId": userId,
      };
}
