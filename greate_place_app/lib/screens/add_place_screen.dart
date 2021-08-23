import 'dart:io';

import 'package:flutter/material.dart';
import 'package:greate_place_app/helpers/location_helper.dart';
import 'package:greate_place_app/models/place.dart';
import 'package:greate_place_app/providers/greate_places.dart';
import 'package:greate_place_app/widgets/image_input.dart';
import 'package:greate_place_app/widgets/location_input.dart';
import 'package:provider/provider.dart';

class AddPlaceScreen extends StatefulWidget {
  static const routeName = '/add-place';

  const AddPlaceScreen({Key? key}) : super(key: key);

  @override
  _AddPlaceScreenState createState() => _AddPlaceScreenState();
}

class _AddPlaceScreenState extends State<AddPlaceScreen> {
  final _titleController = TextEditingController();
  File? _pickedImage;
  PlaceLocation? _pickLocation;

  void _selectImage(File? pickedImage) {
    _pickedImage = pickedImage;
  }

  void selectPlace(double lat, double lng) {
    _pickLocation = PlaceLocation(latitude: lat, longitude: lng, address: '');
  }

  void _savePlace() {
    if (_titleController.text.isEmpty ||
        _pickedImage == null ||
        _pickLocation == null) {
      _showErrorDialog("title or picture is null");
      return;
    }
    Provider.of<GreatePlaces>(context, listen: false)
        .addPlace(_titleController.text, _pickedImage!, _pickLocation!);
    Navigator.of(context).pop();
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('An Error Occurred!'),
        content: Text(message),
        actions: <Widget>[
          TextButton(
            child: Text('Okay'),
            onPressed: () {
              Navigator.of(ctx).pop();
            },
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add a New Place'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
              child: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.all(10),
              child: Column(
                children: [
                  TextField(
                    decoration: InputDecoration(labelText: 'Title'),
                    controller: _titleController,
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  ImageInput(
                    onSelecteImage: (selectedPic) => _selectImage(selectedPic),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  LocationInput(
                    onSelectPlace: selectPlace,
                  )
                ],
              ),
            ),
          )),
          ElevatedButton.icon(
            onPressed: _savePlace,
            icon: Icon(Icons.add),
            label: Text('Add Place'),
            style: ElevatedButton.styleFrom(
                elevation: 0,
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                primary: Theme.of(context).accentColor,
                padding: EdgeInsets.only(top: 10, bottom: 10)),
          )
        ],
      ),
    );
  }
}
