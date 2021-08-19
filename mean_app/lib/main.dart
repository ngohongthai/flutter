import 'package:flutter/material.dart';
import 'package:mean_app/dummy_data.dart';
import 'package:mean_app/models/meal.dart';
import 'package:mean_app/screens/categories_screen.dart';
import 'package:mean_app/screens/category_meal_screen.dart';
import 'package:mean_app/screens/filter_screen.dart';
import 'package:mean_app/screens/meal_detail_screen.dart';
import 'package:mean_app/screens/tab_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  // This widget is the root of your application.
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  Map<String, bool> _filters = {
    'gluten': false,
    'lactose': false,
    'vegan': false,
    'vegetarian': false
  };

  List<Meal> _availableMeals = DUMMY_MEALS;

  void _setFilters(Map<String, bool> filterData) {
    setState(() {
      _filters = filterData;

      _availableMeals = DUMMY_MEALS.where((meal) {
        var _glutenFree = _filters['gluten'] as bool;
        if (_glutenFree && !meal.isGlutenFree) {
          return false;
        }
        var _vegetarian = _filters['vegetarian'] as bool;
        if (_vegetarian && !meal.isVegetarian) {
          return false;
        }
        var _vegan = _filters['vegan'] as bool;
        if (_vegan && !meal.isVegan) {
          return false;
        }
        var _lactoseFree = _filters['lactose'] as bool;
        if (_lactoseFree && !meal.isLactoseFree) {
          return false;
        }
        return true;
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'DeliMeals',
      theme: ThemeData(
        primarySwatch: Colors.pink,
        accentColor: Colors.amber,
        canvasColor: Color.fromRGBO(255, 254, 229, 1),
        fontFamily: 'Raleway',
        textTheme: ThemeData.light().textTheme.copyWith(
            bodyText2: TextStyle(
              color: Color.fromRGBO(20, 51, 51, 1),
            ),
            bodyText1: TextStyle(
              color: Color.fromRGBO(20, 51, 51, 1),
            ),
            headline6: TextStyle(
              fontSize: 20,
              fontFamily: 'RobotoCondensed',
              fontWeight: FontWeight.bold,
            )),
      ),
      //home: CategoriesScreen(),
      initialRoute: '/',
      routes: {
        '/': (ctx) => TabScreen(),
        CategoryMealsScreen.routerName: (ctx) => CategoryMealsScreen(
              availableMeals: _availableMeals,
            ),
        MealDetailScreen.routerName: (ctx) => MealDetailScreen(),
        FiltersScreen.routerName: (ctx) => FiltersScreen(
              saveFilters: _setFilters,
              currentFilter: _filters,
            )
      },
    );
  }
}
