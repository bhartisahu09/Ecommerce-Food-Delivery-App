import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';

class LocationProvider with ChangeNotifier {
  String _currentLocation = '';
  List<String> _savedAddresses = [];
  String? _lastFetchedAddress;

  String get currentLocation => _currentLocation;
  List<String> get savedAddresses => _savedAddresses;
  String? get lastFetchedAddress => _lastFetchedAddress;

  Future<void> fetchCurrentLocation() async {
    try {
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        _currentLocation = 'Location services disabled';
        notifyListeners();
        return;
      }
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          _currentLocation = 'Location permission denied';
          notifyListeners();
          return;
        }
      }
      if (permission == LocationPermission.deniedForever) {
        _currentLocation = 'Location permission permanently denied';
        notifyListeners();
        return;
      }
      Position position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
      List<Placemark> placemarks = await placemarkFromCoordinates(position.latitude, position.longitude);
      if (placemarks.isNotEmpty) {
        final place = placemarks.first;
        final address = [
          place.name,
          place.street,
          place.subLocality,
          place.locality,
          place.administrativeArea,
          place.postalCode,
          place.country
        ].where((e) => e != null && e.isNotEmpty).join(', ');
        _currentLocation = address;
        _lastFetchedAddress = address;
      } else {
        _currentLocation = 'Unknown location';
        _lastFetchedAddress = null;
      }
      notifyListeners();
    } catch (e) {
      _currentLocation = 'Failed to feth location';
      _lastFetchedAddress = null;
      notifyListeners();
    }
  }

  void setCurrentLocation(String location) {
    _currentLocation = location;
    notifyListeners();
  }

  void addAddress(String address) {
    if (!_savedAddresses.contains(address)) {
      _savedAddresses.add(address);
      notifyListeners();
    }
  }

  void removeAddress(String address) {
    _savedAddresses.remove(address);
    notifyListeners();
  }

  List<String> searchAddresses(String query) {
    return _savedAddresses
        .where((address) => address.toLowerCase().contains(query.toLowerCase()))
        .toList();
  }

  String? _selectedLocation;

  String? get selectedLocation => _selectedLocation;

  void setLocation(String location) {
    _selectedLocation = location;
    notifyListeners();
  }
}