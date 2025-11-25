import 'package:flutter/material.dart';
import '../models/meal_detail.dart';
import '../services/api_service.dart';
import 'meal_detail_screen.dart';

class RandomMealScreen extends StatelessWidget {
  const RandomMealScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Случаен Рецепт на Денот'),
        backgroundColor: Theme.of(context).primaryColor,
        foregroundColor: Colors.white,
      ),
      body: FutureBuilder<MealDetail>(
        future: ApiService().fetchRandomMeal(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Грешка при вчитување: ${snapshot.error}'));
          } else if (snapshot.hasData) {
            final meal = snapshot.data!;

            return MealDetailScreen(idMeal: meal.idMeal);

          } else {
            return const Center(child: Text('Нема податоци за случаен рецепт.'));
          }
        },
      ),
    );
  }
}