import 'dart:developer';

import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';

class LocationHelper {
  /// ✅ Get current position (latitude, longitude)
  static Future<Position> getCurrentPosition() async {
    // Step 1: Request location permission first
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        throw Exception('Location permission denied.');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      throw Exception(
        'Location permissions are permanently denied. Please enable them in settings.',
      );
    }

    // Step 2: Check if location service (GPS) is enabled
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // Prompt user to enable location service
      bool opened = await Geolocator.openLocationSettings();
      if (!opened) {
        throw Exception('Please enable location services.');
      }
    }

    // Step 3: Get the current position
    return await Geolocator.getCurrentPosition(
      locationSettings: LocationSettings(accuracy: LocationAccuracy.best),
    );
  }

  /// ✅ Convert coordinates to a readable address (like city name)
  static Future<String?> getDistrictName(Position position) async {
    List<Placemark> placemarks = await placemarkFromCoordinates(
      position.latitude,
      position.longitude,
    );

    if (placemarks.isNotEmpty) {
      log(placemarks.toList().toString());
      return placemarks.first.locality; // city name
    }
    return null;
  }
}
