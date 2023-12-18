import 'dart:async';

import 'package:data_capture/models/position.dart';
import 'package:location/location.dart';

class LocationService {
  final Location _location = Location();
  Future<Position> getCurrentLocation() async {
    try {
      final status = await _location.requestPermission();
      if (status == PermissionStatus.denied) {
        throw 'Please enable location permission to use this feature.';
      } else if (status == PermissionStatus.deniedForever) {
        throw 'Location permission was permanently denied. You can grant permission in your device settings.';
      } else {
        final position = await _location.getLocation();
        return Position(
          latitude: position.latitude!,
          longitude: position.longitude!,
        );
      }
    } catch (e) {
      throw e.toString();
    }
  }
}

LocationService locationService = LocationService();
