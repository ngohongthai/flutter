import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:greate_place_app/helpers/location_helper.dart';
import 'package:greate_place_app/models/place.dart';
import 'package:greate_place_app/screens/map_screen.dart';
import 'package:location/location.dart';

class LocationInput extends StatefulWidget {
  final Function(double, double) onSelectPlace;
  const LocationInput({Key? key, required this.onSelectPlace})
      : super(key: key);

  @override
  _LocationInputState createState() => _LocationInputState();
}

class _LocationInputState extends State<LocationInput> {
  String? _previewImageUrl;
  void _showPreview(double lat, double lng) {
    final staticMapImageUrl =
        LocationHelper.generateLocationPreviewImage(lat, lng);
    setState(() {
      _previewImageUrl = staticMapImageUrl;
    });
  }

  Future<void> _getCurrentLocation() async {
    final locData = await Location().getLocation();
    if (locData.latitude == null || locData.longitude == null) {
      return;
    }
    final staticMapImageUrl = LocationHelper.generateLocationPreviewImage(
        locData.latitude!, locData.longitude!);
    setState(() {
      _previewImageUrl = staticMapImageUrl;
    });
    widget.onSelectPlace(locData.latitude!, locData.longitude!);
  }

  Future<void> _selectedOnMap() async {
    final selectedLocation =
        await Navigator.of(context).push<LatLng>(MaterialPageRoute(
            fullscreenDialog: true,
            builder: (ctx) => MapScreen(
                  initialLocation: PlaceLocation.dummy,
                  isSelecting: true,
                )));
    if (selectedLocation == null) {
      return;
    }
    _showPreview(selectedLocation.latitude, selectedLocation.longitude);
    widget.onSelectPlace(selectedLocation.latitude, selectedLocation.longitude);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          height: 180,
          width: double.infinity,
          alignment: Alignment.center,
          decoration:
              BoxDecoration(border: Border.all(width: 1, color: Colors.grey)),
          child: _previewImageUrl == null
              ? Text(
                  'No location chosen',
                  textAlign: TextAlign.center,
                )
              : Image.network(
                  _previewImageUrl!,
                  fit: BoxFit.cover,
                ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextButton.icon(
                onPressed: _getCurrentLocation,
                icon: Icon(Icons.location_on),
                label: Text('Current Location')),
            TextButton.icon(
                onPressed: _selectedOnMap,
                icon: Icon(Icons.map),
                label: Text('Select on Map'))
          ],
        )
      ],
    );
  }
}
