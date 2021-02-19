import 'package:flutter/material.dart';
import 'package:maps_app/providers/location_service.dart';
import 'package:maps_app/providers/map_service.dart';
import 'package:maps_app/providers/search_service.dart';
import 'package:maps_app/screens/access_gps_screen.dart';
import 'package:maps_app/screens/loading_screen.dart';
import 'package:maps_app/screens/map_screen.dart';
import 'package:provider/provider.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => LocationService(),
        ),
        ChangeNotifierProvider(
          create: (context) => MapService(),
        ),
        ChangeNotifierProvider(
          create: (context) => SearchService(),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Maps App',
        home: LoadingScreen(),
        // home: AccessGpsScreen(),
        routes: {
          AccessGpsScreen.routeName: (_) => AccessGpsScreen(),
          LoadingScreen.routeName: (_) => LoadingScreen(),
          MapScreen.routeName: (_) => MapScreen(),
        },
      ),
    );
  }
}
