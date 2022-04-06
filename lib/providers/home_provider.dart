import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:location/location.dart' as Location;

class HomeProvider extends ChangeNotifier {
  Location.LocationData? _currentPosition;
  String? _address, _dateTime;
  String _addressTitle = "";
  String get addressTitle => _addressTitle;
  bool _isWaiting = false;
  bool get isWaiting => _isWaiting;
  set isWaiting(value) {
    _isWaiting = value;
    notifyListeners();
  }

  set addressTitle(value) {
    _addressTitle = value;
    notifyListeners();
  }

  set currentPosition(value) {
    _currentPosition = value;
    notifyListeners();
  }

  Future<void> getCurrentLocation() async {
    bool _serviceEnabled;
    Location.PermissionStatus _permissionGranted;
    try {
      _serviceEnabled = await Location.Location.instance.serviceEnabled();
      if (!_serviceEnabled) {
        _serviceEnabled = await Location.Location.instance.requestService();
        if (!_serviceEnabled) {
          return;
        }
        _permissionGranted = await Location.Location.instance.hasPermission();
        if (_permissionGranted == Location.PermissionStatus.denied) {
          _permissionGranted =
              await Location.Location.instance.requestPermission();
          if (_permissionGranted != Location.PermissionStatus.granted) {
            return;
          }
        }
      }

      _currentPosition = await Location.Location.instance.getLocation();
      getAddress(
          _currentPosition!.latitude ?? 0, _currentPosition?.longitude ?? 0);
    } catch (e) {}
  }

  Future<void> getAddress(double lat, double lon) async {
    try {
      List<Placemark> placemarks = await placemarkFromCoordinates(
          _currentPosition!.latitude ?? 1, _currentPosition!.longitude ?? 1);

      Placemark place = placemarks[0];

      addressTitle = "${place.locality}";
    } catch (e) {
      print(e);
    }
  }

  Future<void> initializeSettings() async {
    try {
      isWaiting = true;

      await getCurrentLocation();

      isWaiting = false;
    } catch (e) {
      isWaiting = false;
    }
  }
}
