import 'package:async/async.dart';
import 'package:ex01/models.dart';
import 'package:ex01/weatherService.dart';
import 'package:flutter/material.dart';
import 'package:location/location.dart';

enum LocationState { loading, enabled, disabled, requested }

class WeatherChangeNotifier extends ChangeNotifier {
  final WeatherService _weatherService;

  WeatherChangeNotifier(this._weatherService) {}

  late Location location = _weatherService.location;

  // Variable to keep track of the cancelable operation
  CancelableOperation? _fetchLocationOperation;

  List<City> _cities = [
    City(name: 'Amriswil', region: 'Thurgau', country: 'Switzerland'),
    City(name: 'Amsterdam', region: 'Noord-Holland', country: 'Netherlands'),
  ];
  List<City> get cities => _cities;

  String _displayLocation = '';
  String get displayLocation => _displayLocation;

  bool _isLocationEnabled = false;
  bool get isLocationEnabled => _isLocationEnabled;

  LocationState _locationState = LocationState.loading; // Updated to use enum
  LocationState get locationState => _locationState; // Updated to use enum

  String _searchLocation = '';
  String get searchLocation => _searchLocation;

  bool _searchTapped = false;
  bool get searchTapped => _searchTapped;

  Future<void> requestLocationPermission() async {
    final _serviceEnabled = await location.serviceEnabled();
    if (!_serviceEnabled) {
      final _serviceRequest = await location.requestService();
      if (!_serviceRequest) {
        return;
      }
    }

    final _permissionGranted = await location.hasPermission();
    if (_permissionGranted == PermissionStatus.denied) {
      final _permissionRequest = await location.requestPermission();
      if (_permissionRequest != PermissionStatus.granted) {
        return;
      }
    }

    _isLocationEnabled = true;
    _locationState = LocationState.enabled;
    getLocation();
    notifyListeners();
  }

  void onLocationClicked() {
    getLocation();
  }

  void onSearchSubmitted(String value) {
    _searchTapped = false;
    _fetchLocationOperation?.cancel();
    if (value.isEmpty) {
      getLocation();
    }
    // Strip value for max length
    if (value.length > 100) {
      value = value.substring(0, 100);
    }

    _searchLocation = value;
    _displayLocation = _searchLocation;
    notifyListeners();
  }

  void onSearchTap() {
    _searchLocation = '';
    _searchTapped = true;
    searchCities(_searchLocation);
    notifyListeners();
  }

  void onSearchTapOutside() {
    _searchTapped = false;
    notifyListeners();
  }

  void onSearchChanged(String value) {
    _searchLocation = value;
    searchCities(_searchLocation);
    notifyListeners();
  }

  void onCitySelected(City city) {
    _searchTapped = false;
    _searchLocation = city.name;
    _displayLocation = city.name;
    notifyListeners();
  }

  void getLocation() async {
    // Cancel any existing operation before starting a new one
    _fetchLocationOperation?.cancel();

    _fetchLocationOperation = CancelableOperation.fromFuture(
      location.getLocation(),
      onCancel: () => {debugPrint('onCancel')},
    );

    try {
      final _locationData = await _fetchLocationOperation!.value;
      if (!_fetchLocationOperation!.isCanceled) {
        _displayLocation =
            'Lat: ${_locationData.latitude}, Long: ${_locationData.longitude}';
        _isLocationEnabled = true;
        _locationState = LocationState.enabled;
        notifyListeners();
      }
    } catch (e) {
      _searchLocation = '';
      _displayLocation = 'Failed to get location: $e';
      _isLocationEnabled = false;
      _locationState = LocationState.disabled;
      notifyListeners();
    }
  }

  Future<void> searchCities(String name) async {
    _cities = await _weatherService.searchCities(name);
    notifyListeners();
  }
}
