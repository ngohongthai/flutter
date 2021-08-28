import 'package:flutter/material.dart';

void showSnakBarError(BuildContext context, String message) {
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
    content: Text(message),
    backgroundColor: Theme.of(context).errorColor,
  ));
}
