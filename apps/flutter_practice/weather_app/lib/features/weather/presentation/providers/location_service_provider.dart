import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geolocator/geolocator.dart';

import 'package:geocoding/geocoding.dart';

class LocationService {
  /// Retrieves a user-friendly city name from the given position using OS native geocoding.
  Future<String?> getCityNameFromPosition(Position position) async {
    try {
      final placemarks = await placemarkFromCoordinates(
        position.latitude,
        position.longitude,
      );
      if (placemarks.isNotEmpty) {
        final place = placemarks.first;
        // Try to get a meaningful name: Locality (City) -> SubAdmin (District) -> Admin (State)
        final locality = place.locality ?? '';
        final subAdmin = place.subAdministrativeArea ?? '';
        final admin = place.administrativeArea ?? '';
        
        if (locality.isNotEmpty) return locality;
        if (subAdmin.isNotEmpty) return subAdmin;
        if (admin.isNotEmpty) return admin;
      }
    } catch (e) {
      // Fallback if geocoding fails
      return null;
    }
    return null;
  }

  /// Checks for location permission and requests it if necessary.
  /// Returns the current position if permission is granted.
  /// Throws an exception if permission is denied or service is disabled.
  Future<Position> getCurrentPosition() async {
    bool serviceEnabled;

    // Test if location services are enabled.
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      throw Exception('Location services are disabled.');
    }

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        throw Exception('Location permissions are denied.');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      throw Exception('Location permissions are permanently denied, we cannot request permissions.');
    }

    // When we reach here, permissions are granted and we can
    // continue accessing the position of the device.
    return await Geolocator.getCurrentPosition(
      locationSettings: const LocationSettings(
        accuracy: LocationAccuracy.high,
      ),
    );
  }
}

final locationServiceProvider = Provider<LocationService>((ref) {
  return LocationService();
});
