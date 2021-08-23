import 'package:flutter/material.dart';
import 'package:greate_place_app/models/place.dart';
import 'package:greate_place_app/providers/greate_places.dart';
import 'package:greate_place_app/screens/add_place_screen.dart';
import 'package:greate_place_app/screens/map_screen.dart';
import 'package:greate_place_app/screens/place_detail_screen.dart';
import 'package:greate_place_app/screens/places_list_screen.dart';
import 'package:provider/provider.dart';

import 'helpers/custom_route.dart';

void main() {
  runApp(MultiProvider(
    providers: [ChangeNotifierProvider(create: (ctx) => GreatePlaces())],
    child: MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Greate Places',
      theme: ThemeData(
          primarySwatch: Colors.indigo,
          accentColor: Colors.amber,
          pageTransitionsTheme: PageTransitionsTheme(builders: {
            TargetPlatform.android: CustomPageTransitionBuilder(),
            TargetPlatform.iOS: CustomPageTransitionBuilder()
          })),
      home: PlacesListScreen(),
      routes: {
        PlacesListScreen.routeName: (ctx) => PlacesListScreen(),
        PlaceDetailScreen.routeName: (ctx) => PlaceDetailScreen(),
        AddPlaceScreen.routeName: (ctx) => AddPlaceScreen(),
        MapScreen.routeName: (ctx) => MapScreen(
              initialLocation: PlaceLocation.dummy,
            )
      },
    );
  }
}
