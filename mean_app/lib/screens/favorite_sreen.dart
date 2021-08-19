import 'package:flutter/material.dart';
import 'package:mean_app/models/meal.dart';

class FavoriteScreen extends StatelessWidget {
  final List<Meal> favoritedMeal;
  const FavoriteScreen({Key? key, required this.favoritedMeal})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text('You have no favorites yet - start adding some!!!'),
    );
  }
}
