import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../models/meal_detail.dart';
import '../services/api_service.dart';

class MealDetailScreen extends StatelessWidget {
  final String idMeal;

  const MealDetailScreen({super.key, required this.idMeal});

  Future<void> _launchUrl(String url) async {
    final uri = Uri.parse(url);
    if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      throw Exception('Could not launch $url');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Детален Рецепт'),
        backgroundColor: Theme.of(context).primaryColor,
        foregroundColor: Colors.white,
      ),
      body: FutureBuilder<MealDetail>(
        future: ApiService().fetchMealDetail(idMeal),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Грешка: ${snapshot.error}'));
          } else if (snapshot.hasData) {
            final meal = snapshot.data!;

            return SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(10.0),
                    child: Image.network(
                      meal.strMealThumb,
                      width: double.infinity,
                      height: 250,
                      fit: BoxFit.cover,
                    ),
                  ),
                  const SizedBox(height: 16),

                  Text(
                    meal.strMeal,
                    style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.black87),
                  ),
                  const Divider(height: 30),

                  const Text(
                    'Состојки',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.deepOrange),
                  ),
                  const SizedBox(height: 8),

                  ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: meal.ingredients.length,
                    itemBuilder: (context, index) {
                      final ingredient = meal.ingredients[index];
                      final measure = meal.measures[index];
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 4.0),
                        child: Text(
                          '• $measure ${measure.isNotEmpty ? '' : ''} $ingredient',
                          style: const TextStyle(fontSize: 16),
                        ),
                      );
                    },
                  ),

                  const Divider(height: 30),

                  const Text(
                    'Инструкции',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.deepOrange),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    meal.strInstructions,
                    style: const TextStyle(fontSize: 16, height: 1.5),
                  ),

                  const Divider(height: 30),

                  if (meal.strYoutube != null)
                    ElevatedButton.icon(
                      onPressed: () => _launchUrl(meal.strYoutube!),
                      icon: const Icon(Icons.play_circle_fill),
                      label: const Text('Погледнете го видеото (YouTube)'),
                      style: ElevatedButton.styleFrom(
                          foregroundColor: Colors.white,
                          backgroundColor: Colors.red,
                          minimumSize: const Size(double.infinity, 45)
                      ),
                    ),
                  if (meal.strYoutube != null) const SizedBox(height: 20),
                ],
              ),
            );
          } else {
            return const Center(child: Text('Нема пронајдени детали за рецептот.'));
          }
        },
      ),
    );
  }
}