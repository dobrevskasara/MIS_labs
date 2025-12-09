import 'package:flutter/material.dart';
import '../models/category.dart';
import '../screens/meal_list_screen.dart';
import '../models/meal.dart';

class CategoryCard extends StatelessWidget {
  final Category category;
  final List<Meal> favorites;
  final Function(Meal) toggleFavorite;
  final bool Function(Meal) isFavorite;

  const CategoryCard({
    super.key,
    required this.category,
    required this.favorites,
    required this.toggleFavorite,
    required this.isFavorite,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      child: ListTile(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => MealListScreen(
                categoryName: category.strCategory,
                favorites: favorites,
                toggleFavorite: toggleFavorite,
                isFavorite: isFavorite,
              ),
            ),
          );
        },
        contentPadding: const EdgeInsets.all(10),
        leading: SizedBox(
          width: 80,
          height: 80,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(8.0),
            child: Image.network(
              category.strCategoryThumb,
              fit: BoxFit.cover,
              loadingBuilder: (context, child, loadingProgress) {
                if (loadingProgress == null) return child;
                return const Center(
                    child: CircularProgressIndicator(strokeWidth: 2));
              },
              errorBuilder: (context, error, stackTrace) {
                return const Icon(Icons.broken_image,
                    size: 40, color: Colors.grey);
              },
            ),
          ),
        ),
        title: Text(
          category.strCategory,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
        subtitle: Padding(
          padding: const EdgeInsets.only(top: 4.0),
          child: Text(
            category.strCategoryDescription,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(fontSize: 13),
          ),
        ),
        trailing: const Icon(Icons.arrow_forward_ios, size: 16),
      ),
    );
  }
}