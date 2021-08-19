import 'package:flutter/material.dart';
import 'package:mean_app/models/meal.dart';
import 'package:mean_app/screens/categories_screen.dart';
import 'package:mean_app/screens/favorite_sreen.dart';
import 'package:mean_app/widgets/main_drawer.dart';

class TabScreen extends StatefulWidget {
  final List<Meal> favoritedMeals;
  const TabScreen({Key? key, required this.favoritedMeals}) : super(key: key);

  @override
  _TabScreenState createState() => _TabScreenState();
}

class _TabScreenState extends State<TabScreen> {
  //final List<Widget> _page = [CategoriesScreen(), FavoriteScreen()];
  late final List<Map<String, Object>> _page;
  int _selectedPageIndex = 0;

  @override
  void initState() {
    _page = [
      {'page': CategoriesScreen(), 'title': 'Categories'},
      {
        'page': FavoriteScreen(
          favoritedMeal: widget.favoritedMeals,
        ),
        'title': 'Your Favorites'
      }
    ];
    super.initState();
  }

  void _selectPage(int index) {
    setState(() {
      _selectedPageIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_page[_selectedPageIndex]['title'] as String),
      ),
      drawer: MainDrawer(),
      body: _page[_selectedPageIndex]['page'] as Widget,
      bottomNavigationBar: BottomNavigationBar(
        items: [
          BottomNavigationBarItem(
              backgroundColor: Theme.of(context).primaryColor,
              icon: Icon(Icons.category),
              label: 'Categories'),
          BottomNavigationBarItem(
              backgroundColor: Theme.of(context).primaryColor,
              icon: Icon(Icons.star),
              label: 'Favorite')
        ],
        backgroundColor: Theme.of(context).primaryColor,
        onTap: (index) => _selectPage(index),
        unselectedItemColor: Colors.white,
        selectedItemColor: Theme.of(context).accentColor,
        currentIndex: _selectedPageIndex,
        type: BottomNavigationBarType.fixed,
      ),
    );
  }
}
