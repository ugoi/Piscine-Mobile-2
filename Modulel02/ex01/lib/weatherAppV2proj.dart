import 'package:ex01/weatherChangeNotifier.dart';
import 'package:ex01/weatherService.dart';
import 'package:flutter/material.dart';
import 'package:location/location.dart';
import 'package:async/async.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (context) => WeatherChangeNotifier(WeatherService()),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: MyHomePage(
          title: 'Flutter Demo Home Page', weatherService: WeatherService()),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage(
      {super.key, required this.title, required this.weatherService});

  final String title;

  final WeatherService weatherService;

  @override
  State<MyHomePage> createState() => MyHomePageState();
}

class MyHomePageState extends State<MyHomePage> {
  late Location location = widget.weatherService.location;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      final weatherNotifier =
          Provider.of<WeatherChangeNotifier>(context, listen: false);
      await weatherNotifier.requestLocationPermission();
    });
  }

  int _currentIndex = 0;

  final _pageViewController = PageController();

  @override
  void dispose() {
    _pageViewController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<WeatherChangeNotifier>(
      builder: (context, weather, child) {
        return Scaffold(
          appBar: AppBar(
              backgroundColor: Theme.of(context).colorScheme.inversePrimary,
              title: TextField(
                decoration: const InputDecoration(
                  hintText: 'Search',
                  prefixIcon: Icon(Icons.search),
                  border: InputBorder.none,
                ),
                onSubmitted: (value) {
                  weather.onSearchSubmitted(value);
                },
                onTap: () {
                  weather.onSearchTap();
                },
                onTapOutside: (event) {
                  weather.onSearchTapOutside();
                  FocusScope.of(context).unfocus();
                },
                onChanged: (value) {
                  weather.onSearchChanged(value);
                },
              ),
              actions: <Widget>[
                IconButton(
                  icon: const Icon(Icons.navigation),
                  onPressed: () {
                    weather.onLocationClicked();
                  },
                ),
              ]),
          body: weather.searchTapped == true
              ? ListView.builder(
                  itemCount: weather.cities.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                      title: RichText(
                        text: TextSpan(
                          children: [
                            TextSpan(
                              text: weather.cities[index].name,
                              style: TextStyle(
                                  fontWeight:
                                      FontWeight.bold), // Makes text bold
                            ),
                            TextSpan(
                              text: ', ' +
                                  weather.cities[index].region +
                                  ', ' +
                                  weather.cities[index].country,
                              style: TextStyle(
                                  fontWeight: FontWeight
                                      .normal), // Keeps rest of the text normal
                            ),
                          ],
                        ),
                      ),
                      onTap: () {
                        weather.onCitySelected(weather.cities[index]);
                      },
                    );
                  },
                )
              : PageView(
                  controller: _pageViewController,
                  onPageChanged: (int index) {
                    setState(() {
                      _currentIndex = index;
                    });
                  },
                  children: <Widget>[
                    Center(
                      key: const Key('CurrentlyPage'),
                      child: FittedBox(
                        child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              if (weather.locationState ==
                                      LocationState.enabled ||
                                  weather.displayLocation.isNotEmpty) ...[
                                Text('Currently',
                                    style: TextStyle(fontSize: 24)),
                                Text(weather.displayLocation,
                                    style: TextStyle(fontSize: 24)),
                              ] else ...[
                                Text('Location is not enabled',
                                    style: TextStyle(
                                        fontSize: 24, color: Colors.red)),
                              ],
                            ]),
                      ),
                    ),
                    Center(
                      key: const Key('TodayPage'),
                      child: FittedBox(
                        child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              if (weather.locationState ==
                                      LocationState.enabled ||
                                  weather.searchLocation.isNotEmpty) ...[
                                Text('Today', style: TextStyle(fontSize: 24)),
                                Text(weather.displayLocation,
                                    style: TextStyle(fontSize: 24)),
                              ] else ...[
                                Text('Location is not enabled',
                                    style: TextStyle(
                                        fontSize: 24, color: Colors.red)),
                              ],
                            ]),
                      ),
                    ),
                    Center(
                      key: const Key('WeeklyPage'),
                      child: FittedBox(
                        child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              if (weather.locationState ==
                                      LocationState.enabled ||
                                  weather.searchLocation.isNotEmpty) ...[
                                Text('Weekly', style: TextStyle(fontSize: 24)),
                                Text(weather.displayLocation,
                                    style: TextStyle(fontSize: 24)),
                              ] else ...[
                                Text('Location is not enabled',
                                    style: TextStyle(
                                        fontSize: 24, color: Colors.red)),
                              ],
                            ]),
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
            unselectedItemColor: Theme.of(context).colorScheme.onSurface,
            onTap: (int index) {
              _pageViewController.animateToPage(index,
                  duration: const Duration(milliseconds: 500),
                  curve: Curves.easeInOut);
            },
          ),
        );
      },
    );
  }
}
