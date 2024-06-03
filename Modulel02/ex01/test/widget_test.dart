// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:ex01/models.dart';
import 'package:ex01/weatherChangeNotifier.dart';
import 'package:ex01/weatherService.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:location/location.dart';
import 'package:ex01/weatherAppV2proj.dart';
import 'package:provider/provider.dart';

class MockWeatherService extends Mock implements WeatherService {}

class MockLocation extends Mock implements Location {}

void main() {
  late MockWeatherService mockWeatherService;
  late MockLocation mockLocation;

  setUp(() {
    mockWeatherService = MockWeatherService();
    mockLocation = MockLocation();
  });

  void mockLocationDisabled() {
    when(() => mockLocation.serviceEnabled()).thenAnswer((_) async => false);
    when(() => mockLocation.requestService()).thenAnswer((_) async => false);
    when(() => mockLocation.hasPermission())
        .thenAnswer((_) async => PermissionStatus.denied);
    when(() => mockLocation.requestPermission())
        .thenAnswer((_) async => PermissionStatus.denied);
    when(() => mockLocation.getLocation()).thenThrow(ArgumentError);
  }

  void mockLocationEnabled() {
    when(() => mockLocation.serviceEnabled()).thenAnswer((_) async => true);
    when(() => mockLocation.requestService()).thenAnswer((_) async => true);
    when(() => mockLocation.hasPermission())
        .thenAnswer((_) async => PermissionStatus.granted);
    when(() => mockLocation.requestPermission())
        .thenAnswer((_) async => PermissionStatus.granted);
    when(() => mockLocation.getLocation()).thenAnswer((_) async =>
        LocationData.fromMap({'latitude': 38.53, 'longitude': 77.02}));
  }

  void mockLocationEnabledWithDelayedLocation() {
    when(() => mockLocation.serviceEnabled()).thenAnswer((_) async => true);
    when(() => mockLocation.requestService()).thenAnswer((_) async => true);
    when(() => mockLocation.hasPermission())
        .thenAnswer((_) async => PermissionStatus.granted);
    when(() => mockLocation.requestPermission())
        .thenAnswer((_) async => PermissionStatus.granted);
    when(() => mockLocation.getLocation()).thenAnswer((_) async =>
        Future.delayed(Duration(seconds: 2), () {
          return LocationData.fromMap({'latitude': 38.53, 'longitude': 77.02});
        }));
  }

  void mockWeatherServiceLocationDisabled() {
    mockLocationDisabled();
    when(() => mockWeatherService.location).thenReturn(mockLocation);
  }

  void mockWeatherServiceLocationEnabled() {
    mockLocationEnabled();
    when(() => mockWeatherService.location).thenReturn(mockLocation);
  }

  void mockWeatherServiceLocationEnabledWithDelayedLocation() {
    mockLocationEnabledWithDelayedLocation();
    when(() => mockWeatherService.location).thenReturn(mockLocation);
  }

  void mockWeatherServiceSearchCities() {
    when(() => mockWeatherService.searchCities('')).thenAnswer((_) async {
      return [
        City(name: "New York", region: "New York", country: "United States", longitude: 3, latitude: 4)
      ];
    });
  }

  Widget createWidgetUnderTest() {
    return MaterialApp(
      title: 'Flutter Demo Test',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: ChangeNotifierProvider(
        create: (_) => WeatherChangeNotifier(mockWeatherService),
        child: MyHomePage(
            title: 'Flutter Demo Home Page',
            weatherService: mockWeatherService),
      ),
    );
  }

  group("test location", () {
    testWidgets('Displays Location is not enabled',
        (WidgetTester tester) async {
      // Build our app and trigger a frame.

      mockWeatherServiceLocationDisabled();
      await tester.pumpWidget(createWidgetUnderTest());

      // Verify that our counter starts at 0.
      expect(find.text('Location is not enabled'), findsOneWidget);

      // // Tap the '+' icon and trigger a frame.
      // await tester.tap(find.byIcon(Icons.today));
      // await tester.pump();

      // // // Verify that our counter has incremented.
      // // expect(find.text('Today'), findsNothing);
      // expect(find.text('Today'), findsOneWidget);
    });

    testWidgets('Displays Location when it is enabled',
        (WidgetTester tester) async {
      // Setup the mocked services to simulate location being enabled.
      mockWeatherServiceLocationEnabled();

      // Build our app and trigger a frame to render the UI.
      await tester.pumpWidget(createWidgetUnderTest());

      // Wait for all asynchronous operations to complete.
      await tester.pumpAndSettle();

      // Use the mock location data to verify the UI displays the location correctly.
      final expectedDisplayLocation = 'Lat: 38.53, Long: 77.02';
      expect(find.text(expectedDisplayLocation), findsOneWidget);

      // Additional UI checks can be performed here if necessary.
    });

    testWidgets('Displays Currently', (WidgetTester tester) async {
      // Setup the mocked services to simulate location being enabled.
      mockWeatherServiceLocationEnabled();

      // Build our app and trigger a frame to render the UI.
      await tester.pumpWidget(createWidgetUnderTest());

      // Wait for all asynchronous operations to complete.
      await tester.pumpAndSettle();

      final currentlyPageKey = Key('CurrentlyPage');

      final textFinder = find.descendant(
        of: find.byKey(currentlyPageKey),
        matching: find.text('Currently'),
      );

      expect(textFinder, findsOneWidget);

      // Additional UI checks can be performed here if necessary.
    });

    testWidgets('Navigates to Today when the icon is tapped',
        (WidgetTester tester) async {
      // Setup the mocked services to simulate location being enabled.
      mockWeatherServiceLocationEnabled();

      // Build our app and trigger a frame to render the UI.
      await tester.pumpWidget(createWidgetUnderTest());

      // Wait for all asynchronous operations to complete.
      await tester.pumpAndSettle();

      // Tap the 'Todayy' icon and trigger a frame.
      await tester.tap(find.byIcon(Icons.today));

      // Wait for all asynchronous operations to complete.
      await tester.pumpAndSettle();

      final currentlyPageKey = Key('TodayPage');

      final textFinder = find.descendant(
        of: find.byKey(currentlyPageKey),
        matching: find.text('Today'),
      );

      expect(textFinder, findsOneWidget);

      // Additional UI checks can be performed here if necessary.
    });

    testWidgets('Navigates to Weekly when the icon is tapped',
        (WidgetTester tester) async {
      // Setup the mocked services to simulate location being enabled.
      mockWeatherServiceLocationEnabled();

      // Build our app and trigger a frame to render the UI.
      await tester.pumpWidget(createWidgetUnderTest());

      // Wait for all asynchronous operations to complete.
      await tester.pumpAndSettle();

      // Tap the 'Todayy' icon and trigger a frame.
      await tester.tap(find.byIcon(Icons.calendar_view_week));

      // Wait for all asynchronous operations to complete.
      await tester.pumpAndSettle();

      final currentlyPageKey = Key('WeeklyPage');

      final textFinder = find.descendant(
        of: find.byKey(currentlyPageKey),
        matching: find.text('Weekly'),
      );

      expect(textFinder, findsOneWidget);

      // Additional UI checks can be performed here if necessary.
    });

    testWidgets('Loading indicator is displayed when fetching location',
        (WidgetTester tester) async {
      // Setup the mocked services to simulate location being enabled.
      mockWeatherServiceLocationEnabledWithDelayedLocation();

      // Build our app and trigger a frame to render the UI.
      await tester.pumpWidget(createWidgetUnderTest());

      // Wait for all asynchronous operations to complete.
      await tester.pump(const Duration(milliseconds: 500));

      final currentlyPageKey = Key('CurrentlyPage');

      final textFinder = find.descendant(
        of: find.byKey(currentlyPageKey),
        matching: find.text('Loading location...'),
      );

      expect(textFinder, findsOneWidget);

      await tester.pumpAndSettle(Duration(milliseconds: 3000));

      // Additional UI checks can be performed here if necessary.
    });

    testWidgets('Test _onSearchLocationSubmitted functionality',
        (WidgetTester tester) async {
      // Setup your mocked services and the widget under test
      mockWeatherServiceLocationEnabled(); // Assuming this method mocks the location being enabled
      await tester.pumpWidget(createWidgetUnderTest());

      await tester.pumpAndSettle();

      // Find the TextField widget
      final Finder searchField = find.byType(TextField);

      // Enter text into the TextField widget
      await tester.enterText(searchField, 'New York');

      // Simulate text submission
      await tester.testTextInput.receiveAction(TextInputAction.done);

      // Pump the widget so that the changes can take effect
      await tester.pumpAndSettle();

      final currentlyPageKey = Key('CurrentlyPage');

      final textFinder = find.descendant(
        of: find.byKey(currentlyPageKey),
        matching: find.text('New York'),
      );

      // Verify that the _onSearchLocationSubmitted method's logic is executed as expected
      // For example, if you want to check if the display changes or if certain widgets are now present/absent
      expect(textFinder, findsOneWidget);
      // Add additional assertions here to verify the state of your application after the method is called
    });

    testWidgets(
        'If while loading loacation a city is searched, it should not display the loaction after displaying the city',
        (WidgetTester tester) async {
      // Setup your mocked services and the widget under test
      mockWeatherServiceLocationEnabledWithDelayedLocation(); // Assuming this method mocks the location being enabled
      await tester.pumpWidget(createWidgetUnderTest());

      // Wait for all asynchronous operations to complete.
      await tester.pump(const Duration(milliseconds: 500));

      // Find the TextField widget
      final Finder searchField = find.byType(TextField);

      // Enter text into the TextField widget
      await tester.enterText(searchField, 'New York');

      // Simulate text submission
      await tester.testTextInput.receiveAction(TextInputAction.done);

      // Pump the widget so that the changes can take effect
      await tester.pumpAndSettle(Duration(milliseconds: 3000));

      final currentlyPageKey = Key('CurrentlyPage');

      final textFinder = find.descendant(
        of: find.byKey(currentlyPageKey),
        matching: find.text('New York'),
      );

      // Verify that the _onSearchLocationSubmitted method's logic is executed as expected
      // For example, if you want to check if the display changes or if certain widgets are now present/absent
      expect(textFinder, findsOneWidget);
    });
  });

  group("test search bar", () {
    testWidgets(
        "Clicking on search bar only without typing should display list of cities",
        (WidgetTester tester) async {
      mockWeatherServiceLocationEnabled();
      mockWeatherServiceSearchCities();
      await tester.pumpWidget(createWidgetUnderTest());

      await tester.pumpAndSettle();

      final searchField = find.byType(TextField);

      await tester.tap(searchField);

      await tester.pumpAndSettle();

      final listView = find.byType(ListView);

      expect(listView, findsOneWidget);
    });

    testWidgets("Selecting a city from the list should display the city",
        (WidgetTester tester) async {
      mockWeatherServiceLocationEnabled();
      mockWeatherServiceSearchCities();
      await tester.pumpWidget(createWidgetUnderTest());

      await tester.pumpAndSettle();

      final searchField = find.byType(TextField);

      await tester.tap(searchField);

      await tester.pumpAndSettle();

      final listView = find.byType(ListView);

      await tester.tap(find.text('New York'));

      await tester.pumpAndSettle();

      final currentlyPageKey = Key('CurrentlyPage');

      final textFinder = find.descendant(
        of: find.byKey(currentlyPageKey),
        matching: find.text('New York'),
      );

      expect(textFinder, findsOneWidget);
    });
  });
}
