import 'package:flutter/material.dart';
import 'package:meals/data/dummy_data.dart';
import 'package:meals/screens/categories.dart';
import 'package:meals/screens/filters.dart';
import 'package:meals/screens/meals.dart';
import 'package:meals/widgets/main_drawer.dart';
import '../models/meal.dart';

const kInitialFilter = {
  Filters.glutenFree: false,
  Filters.lactosFree: false,
  Filters.vegan: false,
  Filters.vegeterian: false,
};

class TabsScreen extends StatefulWidget {
  const TabsScreen({super.key});

  @override
  State<StatefulWidget> createState() {
    return _TabsScreenState();
  }
}

class _TabsScreenState extends State<TabsScreen> {
  int selectedPageIndex = 0;
  final List<Meal> _favoriteMeals = [];
  Map<Filters, bool> _selectedFilter = kInitialFilter;

  void _showMessage(String message) {
    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
      ),
    );
  }

  void _toggleMealFavorites(Meal meal) {
    final isExisting = _favoriteMeals.contains(meal);
    if (isExisting) {
      setState(() {
        _favoriteMeals.remove(meal);
        _showMessage('Item is removed from favorites');
      });
    } else {
      setState(() {
        _favoriteMeals.add(meal);
        _showMessage('Item is added to favorites');
      });
    }
  }

  void _selectedPage(int index) {
    setState(() {
      selectedPageIndex = index;
    });
  }

  void _setPageFilter(String identifier) async {
    Navigator.of(context).pop();
    if (identifier == 'filter') {
      var result = await Navigator.of(context).push<Map<Filters, bool>>(
        MaterialPageRoute(
          builder: (ctx) => FiltersScreen(
            currentFilter: _selectedFilter,
          ),
        ),
      );
      setState(() {
        _selectedFilter = result ?? kInitialFilter;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    var availableMeals = dummyMeals.where((meal) {
      if (_selectedFilter[Filters.glutenFree]! && !meal.isGlutenFree) {
        return false;
      }
      if (_selectedFilter[Filters.lactosFree]! && !meal.isLactoseFree) {
        return false;
      }
      if (_selectedFilter[Filters.vegan]! && !meal.isVegan) {
        return false;
      }
      if (_selectedFilter[Filters.vegeterian]! && !meal.isVegetarian) {
        return false;
      }
      return true;
    }).toList();

    Widget activePage = CategoriesScreens(
      onToggleFavorites: _toggleMealFavorites,
      availableMeal: availableMeals,
    );
    var activePageTitle = 'Categores';
    if (selectedPageIndex == 1) {
      activePage = MealsScreen(
        meals: _favoriteMeals,
        onToggleFavorites: _toggleMealFavorites,
      );
      activePageTitle = 'Your Favorites';
    }
    return Scaffold(
      appBar: AppBar(
        title: Text(activePageTitle),
      ),
      drawer: MainDrawer(
        onSelectScreen: _setPageFilter,
      ),
      body: activePage,
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: selectedPageIndex,
        onTap: (index) => {_selectedPage(index)},
        items: const [
          BottomNavigationBarItem(
              icon: Icon(
                Icons.set_meal,
              ),
              label: 'Categories'),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.star,
            ),
            label: 'Favorites',
          ),
        ],
      ),
    );
  }
}
