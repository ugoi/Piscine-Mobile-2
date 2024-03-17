import 'dart:math';

import 'package:flutter/material.dart';
import 'package:location/location.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // TRY THIS: Try running your application with "flutter run". You'll see
        // the application has a purple toolbar. Then, without quitting the app,
        // try changing the seedColor in the colorScheme below to Colors.green
        // and then invoke "hot reload" (save your changes or press the "hot
        // reload" button in a Flutter-supported IDE, or press "r" if you used
        // the command line to start the app).
        //
        // Notice that the counter didn't reset back to zero; the application
        // state is not lost during the reload. To reset the state, use hot
        // restart instead.
        //
        // This works for code too, not just values: Most code changes can be
        // tested with just a hot reload.
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      appBar: AppBar(
          // TRY THIS: Try changing the color here to a specific color (to
          // Colors.amber, perhaps?) and trigger a hot reload to see the AppBar
          // change color while the other colors stay the same.
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
          // Here we take the value from the MyHomePage object that was created by
          // the App.build method, and use it to set our appbar title.
          title: TextField(
            decoration: const InputDecoration(
              hintText: 'Search',
              prefixIcon: Icon(Icons.search),
              border: InputBorder.none,
            ),
            onChanged: (value) {
              _onSearchChanged(value);
            },
            onSubmitted: (value) {
              _onSearchLocationSubmitted(value);
            },
          ),
          // PLace button after the title
          actions: <Widget>[
            IconButton(
              icon: const Icon(Icons.navigation),
              onPressed: () {
                _onLocationClicked();
              },
            ),
          ]),
      body: PageView(
        controller: _pageViewController,
        onPageChanged: (int index) {
          setState(() {
            _currentIndex = index;
          });
        },
        // Center is a layout widget. It takes a single child and positions it
        // in the middle of the parent.
        children: <Widget>[
          CurrentlyPage(
            isLocationEnabled: _isLocationEnabled,
            searchLocation: _searchLocation,
            displayLocation: _displayWeather,
            isSearchTapped: _displaySearch,
            locationCities: _locationCities,
            onLocationSelected: (Map<String, dynamic> selectedLocation) {
              setState(() {
                _selectedLocation =
                    selectedLocation; // Update the state with the selected location
                _displaySearch =
                    false; // You might want to hide the search result after selection
                _displayWeather = selectedLocation['name'];
                print('Selected location: $_selectedLocation');
              });
            },
          ),
          Center(
            child: FittedBox(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: (_isLocationEnabled || _searchLocation.isNotEmpty)
                    ? <Widget>[
                        Text('Today', style: TextStyle(fontSize: 24)),
                        Text(_displayWeather, style: TextStyle(fontSize: 24)),
                      ]
                    : <Widget>[
                        Text('Location is not enabled',
                            style: TextStyle(fontSize: 24, color: Colors.red)),
                      ],
              ),
            ),
          ),
          Center(
            child: FittedBox(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: (_isLocationEnabled || _searchLocation.isNotEmpty)
                    ? <Widget>[
                        Text('Weekly', style: TextStyle(fontSize: 24)),
                        Text(_displayWeather, style: TextStyle(fontSize: 24)),
                      ]
                    : <Widget>[
                        Text('Location is not enabled',
                            style: TextStyle(fontSize: 24, color: Colors.red)),
                      ],
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.sunny),
            label: 'Currently',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.today),
            label: 'Today',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.calendar_view_week),
            label: 'Weekly',
          ),
        ],
        selectedItemColor: Theme.of(context).colorScheme.primary,
        // TRY THIS: Change the color of the unselected items to a specific color
        // (to Colors.blue, perhaps?) and trigger a hot reload to see the
        // BottomNavigationBar change color while the other colors stay the same.
        unselectedItemColor: Theme.of(context).colorScheme.onSurface,
        onTap: (int index) {
          _pageViewController.animateToPage(index,
              duration: const Duration(milliseconds: 500),
              curve: Curves.easeInOut);
        },
      ),
    );
  }

  @override
  void initState() {
    debugPrint('initState');
    super.initState();
    _requestLocationPermission();
  }

  @override
  void dispose() {
    _pageViewController.dispose();
    super.dispose();
  }

  void _onSearchTap() {
    setState(() {
      _displaySearch = true;
      print('Search tapped');
    });
  }

  void _onSearchTapOutside() {
    print('Search tap outside');
    setState(() {
      _displaySearch = false;
    });
  }

  void _onSearchLocationSubmitted(String value) {
    print('Search submitted: $value');
    // Strip value for max length
    if (value.length > 100) {
      value = value.substring(0, 100);
    }
    setState(() {
      _selectedLocation = _locationCities[0];
      _displayWeather = _selectedLocation['name'];

      _displaySearch = false;
      print('Search submitted: $_displaySearch');
    });
  }

  void _onSearchChanged(String value) {
    print('Search changed: $value');
    // Strip value for max length
    if (value.length > 100) {
      value = value.substring(0, 100);
    }
    setState(() {
      _displaySearch = true;
      print('Search changed: $_displaySearch');
      _searchLocation = value;
      _setLocationCities(_searchLocation);
    });
  }

  void _setLocationCities(String search) {
    setState(() {
      _locationCities = _geocodingSearch(search);
    });
  }

  List<Map<String, dynamic>> _geocodingSearch(String search) {
    List<Map<String, dynamic>> _locationCities = [
      {
        "name": "Paris",
        "region": "Ile-de-France",
        "country": "France",
        "latitude": 48.85341,
        "longitude": 2.3488,
      },
      {
        "name": "Par",
        "region": "England",
        "country": "United Kingdom",
        "latitude": 48.85341,
        "longitude": 2.3488,
      },
      {
        "name": "Par",
        "region": "Van",
        "country": "Turkey",
        "latitude": 48.85341,
        "longitude": 2.3488,
      },
    ];
    return _locationCities;
  }

  void _requestLocationPermission() async {
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
    setState(() {
      _isLocationEnabled = true;
    });
    _getLocation();
  }

  void _getLocation() async {
    try {
      setState(() {
        _displayWeather = 'Loading location...';
      });
      final _locationData = await location.getLocation();
      setState(() {
        _displayWeather =
            'Lat: ${_locationData.latitude}, Long: ${_locationData.longitude}';
        _isLocationEnabled = true;
      });
    } catch (e) {
      setState(() {
        _searchLocation = '';
        _displayWeather = 'Failed to get location: $e';
        _isLocationEnabled = false;
      });
    }
  }

  int _currentIndex = 0;

  final _pageViewController = PageController();

  void _onLocationClicked() {
    _getLocation();
  }

  Location location = Location();

  String _displayWeather = 'Loading location...';
  bool _isLocationEnabled = false;
  bool _displaySearch = false;
  String _searchLocation = '';
  Map<String, dynamic> _selectedLocation = {};

  List<Map<String, dynamic>> _locationCities = [];
}

class CurrentlyPage extends StatelessWidget {
  final bool _isLocationEnabled;
  final String _searchLocation;
  final String _displayWeather;
  final bool _displaySearch;
  final List<Map<String, dynamic>> _locationCities;
  final Function(Map<String, dynamic>) onLocationSelected;

  const CurrentlyPage({
    Key? key,
    required this.onLocationSelected,
    required bool isLocationEnabled,
    required String searchLocation,
    required String displayLocation,
    required bool isSearchTapped,
    required List<Map<String, dynamic>> locationCities,
  })  : _isLocationEnabled = isLocationEnabled,
        _searchLocation = searchLocation,
        _displayWeather = displayLocation,
        _displaySearch = isSearchTapped,
        _locationCities = locationCities,
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: _displaySearch ? _buildSearchResults() : _buildContent(),
    );
  }

  Widget _buildSearchResults() {
    return ListView.builder(
      itemCount: _locationCities.length, // Use the length of your data list
      itemBuilder: (context, index) {
        // Access the current city's data
        final city = _locationCities[index];

        // Use this data to populate the ListTile
        return ListTile(
          title: Text(city['name']), // Display the city name
          subtitle: Text(
              '${city['region']}, ${city['country']}'), // Display the region and country
          onTap: () {
            // Optional: Handle onTap action, for example, update the UI based on the selected item
            print('You tapped on ${city['name']}');
            onLocationSelected(city);
          },
        );
      },
    );
  }

  Widget _buildContent() {
    return FittedBox(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: _isLocationEnabled || _searchLocation.isNotEmpty
            ? <Widget>[
                Text('Currently', style: TextStyle(fontSize: 24)),
                Text(_displayWeather, style: TextStyle(fontSize: 24)),
              ]
            : <Widget>[
                Text('Location is not enabled',
                    style: TextStyle(fontSize: 24, color: Colors.red)),
              ],
      ),
    );
  }
}
