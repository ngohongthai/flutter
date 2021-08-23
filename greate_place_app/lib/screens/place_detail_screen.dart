import 'package:flutter/material.dart';

class PlaceDetailScreen extends StatelessWidget {
  static const routeName = '/places-detail';

  const PlaceDetailScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Place detail'),
      ),
      body: Center(
        child: Text('place detail screen'),
      ),
    );
  }
}
