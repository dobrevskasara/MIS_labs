import 'package:flutter/material.dart';
import '../models/meal.dart';
import '../screens/meal_detail_screen.dart';

class FavoritesScreen extends StatelessWidget {
  final List<Meal> favorites;

  const FavoritesScreen({super.key, required this.favorites});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Омилени рецепти'),
      ),
      body: favorites.isEmpty
          ? const Center(
        child: Text(
          'Немате додадено омилени рецепти.',
          style: TextStyle(fontSize: 16),
        ),
      )
          : ListView.builder(
        itemCount: favorites.length,
        itemBuilder: (context, index) {
          final meal = favorites[index];
          return Card(
            margin:
            const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            child: ListTile(
              leading: SizedBox(
                width: 60,
                height: 60,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8.0),
                  child: Image.network(
                    meal.strMealThumb,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              title: Text(
                meal.strMeal,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) =>
                        MealDetailScreen(idMeal: meal.idMeal),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}
