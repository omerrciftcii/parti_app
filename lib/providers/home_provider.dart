import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:location/location.dart' as Location;

class HomeProvider extends ChangeNotifier {
  Location.LocationData? _currentPosition;
  String? _address, _dateTime;
  String _addressTitle = "";
  String get addressTitle => _addressTitle;
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

    var address = getAddress(
        _currentPosition!.latitude ?? 0, _currentPosition?.longitude ?? 0);
  }

  Future<void> getAddress(double lat, double lon) async {
    try {
      List<Placemark> placemarks = await placemarkFromCoordinates(
          _currentPosition!.latitude ?? 1, _currentPosition!.longitude ?? 1);

      Placemark place = placemarks[0];

      addressTitle = "${place.locality}, ${place.postalCode}, ${place.country}";
    } catch (e) {
      print(e);
    }
  }
}
