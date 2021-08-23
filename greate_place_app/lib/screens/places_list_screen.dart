import 'package:flutter/material.dart';
import 'package:greate_place_app/providers/greate_places.dart';
import 'package:greate_place_app/screens/add_place_screen.dart';
import 'package:greate_place_app/screens/place_detail_screen.dart';
import 'package:provider/provider.dart';

class PlacesListScreen extends StatelessWidget {
  static const routeName = '/places-list';

  const PlacesListScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Your places'),
          actions: [
            IconButton(
                onPressed: () {
                  Navigator.of(context).pushNamed(AddPlaceScreen.routeName);
                },
                icon: Icon(Icons.add))
          ],
        ),
        body: FutureBuilder(
          future: Provider.of<GreatePlaces>(context, listen: false)
              .fetchAndSetPlaces(),
          builder: (ctx, snapshot) => snapshot.connectionState ==
                  ConnectionState.waiting
              ? Center(
                  child: CircularProgressIndicator(),
                )
              : Consumer<GreatePlaces>(
                  builder: (ctx, place, ch) => (place.items.length <= 0)
                      ? ch!
                      : ListView.builder(
                          itemCount: place.items.length,
                          itemBuilder: (ctx, i) => ListTile(
                            leading: CircleAvatar(
                              backgroundImage: FileImage(
                                place.items[i].image,
                              ),
                            ),
                            title: Text(place.items[i].title),
                            onTap: () {
                              Navigator.of(context).pushNamed(
                                  PlaceDetailScreen.routeName,
                                  arguments: place.items[i].id);
                            },
                          ),
                        ),
                  child: Center(
                    child: const Text('Got no places yet, start adding some!'),
                  ),
                ),
        ));
  }
}
