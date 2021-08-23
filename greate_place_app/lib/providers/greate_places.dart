import 'dart:io';

import 'package:flutter/material.dart';
import 'package:greate_place_app/models/place.dart';

class GreatePlaces with ChangeNotifier {
  List<Place> _items = [];

  List<Place> get items {
    return [..._items];
  }

  void addPlace(String title, File image) {
    final newPlace = Place(
        id: DateTime.now().toString(),
        title: title,
        location: PlaceLocation(latitude: 0, longitude: 0, address: "..."),
        image: image);
    _items.add(newPlace);
    notifyListeners();
  }
}
