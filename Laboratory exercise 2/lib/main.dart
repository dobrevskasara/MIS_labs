import 'package:flutter/material.dart';
import 'screens/category_list_screen.dart';
import 'models/meal.dart';
import 'screens/favorites_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  List<Meal> favorites = [];

  void toggleFavorite(Meal meal) {
    final exists = favorites.any((m) => m.idMeal == meal.idMeal);

    if (exists) {
      favorites.removeWhere((m) => m.idMeal == meal.idMeal);
    } else {
      favorites.add(meal);
    }

    setState(() {});
  }

  bool isFavorite(Meal meal) {
    return favorites.any((m) => m.idMeal == meal.idMeal);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'MealDB Рецепти',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        useMaterial3: true,
      ),
      home: CategoryListScreen(
        favorites: favorites,
        toggleFavorite: toggleFavorite,
        isFavorite: isFavorite,
      ),
      routes: {
        '/favorites': (_) => FavoritesScreen(favorites: favorites),
      },
    );
  }
}