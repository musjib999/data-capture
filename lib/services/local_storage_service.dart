import 'package:data_capture/models/captured_data_model.dart';
import 'package:data_capture/models/user.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LocalStorageService {
  static const String _keyUserData = 'user_data';

  static Future<void> saveUserData(UserData userData) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString(_keyUserData, userData.toRawJson());
  }

  static Future<UserData?> getUserData() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? userDataJson = prefs.getString(_keyUserData);

    if (userDataJson != null && userDataJson.isNotEmpty) {
      return UserData.fromRawJson(userDataJson);
    } else {
      return null;
    }
  }

  Future<void> saveCapturedData(CapturedData capturedData) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    List<String>? capturedDataStrings = prefs.getStringList('data');
    List<String> encodedDataList = capturedDataStrings ?? [];

    encodedDataList.add(capturedData.toRawJson());
    await prefs.setStringList('data', encodedDataList);
  }

  Future<List<CapturedData>> getCapturedData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    List<String>? capturedDataStrings = prefs.getStringList('data');
    if (capturedDataStrings == null) {
      return [];
    }

    List<CapturedData> capturedDataList = capturedDataStrings
        .map((data) => CapturedData.fromRawJson(data))
        .toList();

    return capturedDataList;
  }

  Future<void> deleteCapturedData(DateTime createdAt) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    List<String>? capturedDataStrings = prefs.getStringList('data');
    List<String> updatedDataList = capturedDataStrings ?? [];

    bool removed = false;
    updatedDataList.removeWhere((data) {
      CapturedData storedData = CapturedData.fromRawJson(data);
      if (storedData.createdAt == createdAt) {
        removed = true;
        return true;
      }
      return false;
    });

    if (removed) {
      await prefs.setStringList('data', updatedDataList);
    } else {
      throw 'Record not found';
    }
  }

  static Future<void> clearDataField() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    await prefs.remove('data');
  }
}
