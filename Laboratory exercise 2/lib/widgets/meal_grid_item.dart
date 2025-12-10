import 'package:flutter/material.dart';
import '../models/meal.dart';
import '../screens/meal_detail_screen.dart';
import '../services/firebase_service.dart';

class MealGridItem extends StatelessWidget {
  final Meal meal;
  final FirebaseService firebaseService;

  const MealGridItem({
    super.key,
    required this.meal,
    required this.firebaseService,
  });

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<Meal>>(
      stream: firebaseService.getFavoritesStream(),
      builder: (context, snapshot) {
        final favorites = snapshot.data ?? [];
        final isFav = favorites.any((m) => m.idMeal == meal.idMeal);

        return InkWell(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => MealDetailScreen(idMeal: meal.idMeal),
              ),
            );
          },
          child: Stack(
            children: [
              Card(
                elevation: 4,
                clipBehavior: Clip.antiAlias,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Expanded(
                      child: Image.network(
                        meal.strMealThumb,
                        fit: BoxFit.cover,
                        loadingBuilder: (context, child, loadingProgress) {
                          if (loadingProgress == null) return child;
                          return const Center(
                              child:
                              CircularProgressIndicator(strokeWidth: 2));
                        },
                        errorBuilder: (context, error, stackTrace) {
                          return const Center(
                              child: Icon(Icons.food_bank,
                                  size: 50, color: Colors.grey));
                        },
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        meal.strMeal,
                        textAlign: TextAlign.center,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 14),
                      ),
                    ),
                  ],
                ),
              ),
              Positioned(
                top: 4,
                right: 4,
                child: IconButton(
                  icon: Icon(
                    isFav ? Icons.favorite : Icons.favorite_border,
                    color: isFav ? Colors.red : Colors.grey,
                  ),
                  onPressed: () {
                    if (isFav) {
                      firebaseService.removeFavorite(meal.idMeal);
                    } else {
                      firebaseService.addFavorite(meal);
                    }
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
