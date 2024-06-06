import 'package:ex01/models.dart';
import 'package:ex01/weatherChangeNotifier.dart';
import 'package:ex01/weatherRepository.dart';
import 'package:ex01/weatherService.dart';
import 'package:flutter/material.dart';
import 'package:location/location.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(ChangeNotifierProvider(
    create: (context) => WeatherChangeNotifier(
        weatherRepository: WeatherRepository(
            weatherService: WeatherService(httpClient: http.Client()))),
    child: const MyApp(),
  ));
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
      home: MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => MyHomePageState();
}

class MyHomePageState extends State<MyHomePage> {
  late final PageController _pageViewController;

  @override
  void initState() {
    super.initState();
    _pageViewController = PageController();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      final weatherNotifier =
          Provider.of<WeatherChangeNotifier>(context, listen: false);
      await weatherNotifier.requestLocationPermission();
    });
  }

  int _currentIndex = 0;

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
          appBar: WeatherAppBar(context, weather),
          body: Stack(children: <Widget>[
            PageView(
              controller: _pageViewController,
              onPageChanged: (int index) {
                setState(() {
                  _currentIndex = index;
                });
              },
              children: <Widget>[
                CurrentlyPage(),
                TodayPage(),
                WeeklyPage(),
              ],
            ),
            if (weather.searchTapped) CitySuggestions(),
          ]),
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

  AppBar WeatherAppBar(BuildContext context, WeatherChangeNotifier weather) {
    return AppBar(
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
          // onTapOutside: (event) {
          //   weather.onSearchTapOutside();
          //   FocusScope.of(context).unfocus();
          // },
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
        ]);
  }
}

class CitySuggestions extends StatelessWidget {
  const CitySuggestions({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final weather = Provider.of<WeatherChangeNotifier>(context);
    return Container(
      color: Colors.white,
      child: Column(
        children: <Widget>[
          Expanded(
            child: FutureBuilder(
                future: weather.cities,
                builder:
                    (BuildContext context, AsyncSnapshot<List<City>> snapshot) {
                  if (snapshot.hasData) {
                    return ListView.builder(
                      itemCount: snapshot.data!.length,
                      itemBuilder: (context, index) {
                        return ListTile(
                          title: RichText(
                            text: TextSpan(
                              children: [
                                TextSpan(
                                  text: snapshot.data![index].name,
                                  style: TextStyle(
                                      fontWeight:
                                          FontWeight.bold), // Makes text bold
                                ),
                                TextSpan(
                                  text: ', ' +
                                      (snapshot.data?[index].region ?? '') +
                                      ', ' +
                                      (snapshot.data?[index].country ?? ''),
                                  style: TextStyle(
                                      fontWeight: FontWeight
                                          .normal), // Keeps rest of the text normal
                                ),
                              ],
                            ),
                          ),
                          onTap: () {
                            weather.onCitySelected(snapshot.data![index]);
                          },
                        );
                      },
                    );
                  } else {
                    return CircularProgressIndicator();
                  }
                }),
          ),
        ],
      ),
    );
  }
}

class CurrentlyPage extends StatelessWidget {
  const CurrentlyPage({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final weather = Provider.of<WeatherChangeNotifier>(context);
    return Center(
      key: const Key('CurrentlyPage'),
      child: FittedBox(
        child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              FutureBuilder(
                  future: weather.isLocationEnabled,
                  builder:
                      (BuildContext context, AsyncSnapshot<bool> snapshot) {
                    if (snapshot.hasData) {
                      if (snapshot.data!) {
                        return FutureBuilder(
                            future: weather.weatherData,
                            builder: (BuildContext context,
                                AsyncSnapshot<WeatherData> snapshot) {
                              if (snapshot.hasData) {
                                return DataTable(columns: [
                                  DataColumn(
                                    label: Text('Date'),
                                  ),
                                  DataColumn(
                                    label: Text('Temperature'),
                                  ),
                                  DataColumn(label: Text('Weather')),
                                  DataColumn(label: Text('Wind Speed')),
                                ], rows: [
                                  DataRow(cells: [
                                    DataCell(Text('Currently')),
                                    DataCell(Text(
                                        '${snapshot.data?.currently?.temperature ?? "N/A"}')),
                                    DataCell(Text(
                                        '${snapshot.data?.currently?.weatherCode?.code ?? "N/A"}')),
                                    DataCell(Text(
                                        '${snapshot.data?.currently?.windSpeed ?? "N/A"}'))
                                  ]),
                                ]);
                              } else {
                                return CircularProgressIndicator();
                              }
                            });
                      } else {
                        return Text('Location is not enabled',
                            style: TextStyle(fontSize: 24, color: Colors.red));
                      }
                    } else {
                      return CircularProgressIndicator();
                    }
                  })
            ]),
      ),
    );
  }
}

class TodayPage extends StatelessWidget {
  const TodayPage({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final weather = Provider.of<WeatherChangeNotifier>(context);
    return Center(
      key: const Key('TodayPage'),
      child: FittedBox(
        child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              FutureBuilder(
                  future: weather.isLocationEnabled,
                  builder:
                      (BuildContext context, AsyncSnapshot<bool> snapshot) {
                    if (snapshot.hasData) {
                      if (snapshot.data!) {
                        return FutureBuilder(
                            future: weather.weatherData,
                            builder: (BuildContext context,
                                AsyncSnapshot<WeatherData> snapshot) {
                              if (snapshot.hasData) {
                                return DataTable(
                                    columns: [
                                      DataColumn(
                                        label: Text('Date'),
                                      ),
                                      DataColumn(
                                        label: Text('Temperature'),
                                      ),
                                      DataColumn(label: Text('Weather')),
                                      DataColumn(label: Text('Wind Speed')),
                                    ],
                                    rows: (snapshot.data?.today ?? [])
                                        .map(
                                          (e) => DataRow(cells: [
                                            DataCell(Text('${e.time}')),
                                            DataCell(Text(
                                                '${e.temperature ?? "N/A"}')),
                                            DataCell(Text(
                                                '${e.weatherCode?.code ?? "N/A"}')),
                                            DataCell(
                                                Text('${e.windSpeed ?? "N/A"}'))
                                          ]),
                                        )
                                        .toList());
                              } else {
                                return CircularProgressIndicator();
                              }
                            });
                      } else {
                        return Text('Location is not enabled',
                            style: TextStyle(fontSize: 24, color: Colors.red));
                      }
                    } else {
                      return CircularProgressIndicator();
                    }
                  })
            ]),
      ),
    );
  }
}

class WeeklyPage extends StatelessWidget {
  const WeeklyPage({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final weather = Provider.of<WeatherChangeNotifier>(context);
    return Center(
      key: const Key('WeeklyPage'),
      child: FittedBox(
        child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              FutureBuilder(
                  future: weather.isLocationEnabled,
                  builder:
                      (BuildContext context, AsyncSnapshot<bool> snapshot) {
                    if (snapshot.hasData) {
                      if (snapshot.data!) {
                        return FutureBuilder(
                            future: weather.weatherData,
                            builder: (BuildContext context,
                                AsyncSnapshot<WeatherData> snapshot) {
                              if (snapshot.hasData) {
                                return DataTable(
                                    columns: [
                                      DataColumn(
                                        label: Text('Date'),
                                      ),
                                      DataColumn(
                                        label: Text('Min Temperature'),
                                      ),
                                      DataColumn(
                                          label: Text('Max Temperature')),
                                      DataColumn(label: Text('Weather Code')),
                                    ],
                                    rows: (snapshot.data?.weekly ?? [])
                                        .map(
                                          (e) => DataRow(cells: [
                                            DataCell(Text('${e.time}')),
                                            DataCell(Text(
                                                '${e.minTemperature ?? "N/A"}')),
                                            DataCell(Text(
                                                '${e.maxTemperature ?? "N/A"}')),
                                            DataCell(Text(
                                                '${e.weatherCode?.code ?? "N/A"}'))
                                          ]),
                                        )
                                        .toList());
                              } else {
                                return CircularProgressIndicator();
                              }
                            });
                      } else {
                        return Text('Location is not enabled',
                            style: TextStyle(fontSize: 24, color: Colors.red));
                      }
                    } else {
                      return CircularProgressIndicator();
                    }
                  })
            ]),
      ),
    );
  }
}
