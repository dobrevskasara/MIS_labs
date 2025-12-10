import 'package:flutter/material.dart';
import '../models/meal.dart';
import '../screens/meal_detail_screen.dart';
import '../services/firebase_service.dart';

class FavoritesScreen extends StatelessWidget {
  final FirebaseService firebaseService = FirebaseService();

  FavoritesScreen({super.key, required FirebaseService firebaseService});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Омилени рецепти'),
      ),
      body: StreamBuilder<List<Meal>>(
        stream: firebaseService.getFavoritesStream(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          final favorites = snapshot.data!;
          if (favorites.isEmpty) {
            return const Center(
              child: Text(
                'Немате додадено омилени рецепти.',
                style: TextStyle(fontSize: 16),
              ),
            );
          }

          return ListView.builder(
            itemCount: favorites.length,
            itemBuilder: (context, index) {
              final meal = favorites[index];
              return Card(
                margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
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
                  trailing: IconButton(
                    icon: const Icon(Icons.delete),
                    onPressed: () {
                      firebaseService.removeFavorite(meal.idMeal);
                    },
                  ),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => MealDetailScreen(idMeal: meal.idMeal),
                      ),
                    );
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }
}
