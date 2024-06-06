import 'package:ex01/models.dart';
import 'package:ex01/weatherRepository.dart';
import 'package:flutter/material.dart';
import 'package:location/location.dart';

enum LocationState { loading, enabled, disabled, requested }

class WeatherLocation {
  final double latitude;
  final double longitude;

  WeatherLocation({required this.latitude, required this.longitude});
}

class WeatherChangeNotifier extends ChangeNotifier {
  final WeatherRepository weatherRepository;

  WeatherChangeNotifier({required this.weatherRepository});

  late Location location = weatherRepository.location;

  // Variable to keep track of the cancelable operation
  Future<LocationData> _fetchLocationOperation =
      Future.value(LocationData.fromMap({}));
  Future<LocationData> get fetchLocationOperation => _fetchLocationOperation;

  Future<List<City>> _cities = Future.value([]);
  Future<List<City>> get cities => _cities;

  City? _city = null;
  City? get city => _city;

  String _displayLocation = '';
  String get displayLocation => _displayLocation;

  Future<bool>? _isLocationEnabled = null;
  Future<bool>? get isLocationEnabled => _isLocationEnabled;

  LocationState _locationState = LocationState.loading; // Updated to use enum
  LocationState get locationState => _locationState; // Updated to use enum

  String _searchLocation = '';
  String get searchLocation => _searchLocation;

  bool _searchTapped = false;
  bool get searchTapped => _searchTapped;

  Future<WeatherData>? _weatherData;
  Future<WeatherData>? get weatherData => _weatherData;

  Future<void> requestLocationPermission() async {
    final _serviceEnabled = await location.serviceEnabled();
    if (!_serviceEnabled) {
      final _serviceRequest = await location.requestService();
      if (!_serviceRequest) {
        _isLocationEnabled = Future.value(false);
        return;
      }
    }

    final _permissionGranted = await location.hasPermission();
    if (_permissionGranted == PermissionStatus.denied) {
      final _permissionRequest = await location.requestPermission();
      if (_permissionRequest != PermissionStatus.granted) {
        _isLocationEnabled = Future.value(false);
        return;
      }
    }

    _isLocationEnabled = Future.value(true);
    _locationState = LocationState.enabled;
    getLocation();
    notifyListeners();
  }

  void onLocationClicked() {
    getLocation();
  }

  void onSearchSubmitted(String value) {
    _searchTapped = false;
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
    _searchLocation = city.name ?? '';
    _displayLocation = city.name ?? '';
    _city = city;
    getWeatherForLocation(
        WeatherLocation(latitude: city.latitude!, longitude: city.longitude!));

    notifyListeners();
  }

  Future<void> getLocation() async {
    _fetchLocationOperation = location.getLocation();
    notifyListeners();
    try {
      final LocationData locationData = await _fetchLocationOperation;
      _displayLocation =
          'Latitude: ${locationData.latitude}, Longitude: ${locationData.longitude}';
      _locationState = LocationState.enabled;
      _weatherData = weatherRepository.getWeatherData(locationData);
      notifyListeners();
    } catch (e) {
      _locationState = LocationState.disabled;
    }
  }

  Future<void> searchCities(String name) async {
    _cities = weatherRepository.getCities(name);
    notifyListeners();
  }

  Future<void> getWeatcherForCurrentLocation() async {
    LocationData currentLocation = await location.getLocation();
    _weatherData = weatherRepository.getWeatherData(currentLocation);
    notifyListeners();
  }

  Future<void> getWeatherForLocation(WeatherLocation location) async {
    LocationData locationData = LocationData.fromMap(
        {'latitude': location.latitude, 'longitude': location.longitude});
    _weatherData = weatherRepository.getWeatherData(locationData);
    notifyListeners();
  }
}
