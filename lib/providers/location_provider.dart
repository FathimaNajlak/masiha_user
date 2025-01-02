import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';

class LocationProvider extends ChangeNotifier {
  Position? currentPosition;
  bool isLoading = true;
  String? error;

  Future<void> getCurrentLocation() async {
    isLoading = true;
    error = null;
    notifyListeners();

    try {
      final status = await Permission.location.request();

      if (status.isGranted) {
        currentPosition = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high,
        );
      } else {
        error = 'Location permission denied';
      }
    } catch (e) {
      error = e.toString();
    }

    isLoading = false;
    notifyListeners();
  }
}
