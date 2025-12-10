import 'package:flutter/material.dart';
import '../models/meal.dart';
import '../services/api_service.dart';
import '../widgets/meal_grid_item.dart';
import '../services/firebase_service.dart';

class MealListScreen extends StatefulWidget {
  final String categoryName;
  final FirebaseService firebaseService;

  const MealListScreen({
    super.key,
    required this.categoryName,
    required this.firebaseService,
  });

  @override
  State<MealListScreen> createState() => _MealListScreenState();
}

class _MealListScreenState extends State<MealListScreen> {
  late Future<List<Meal>> _mealsFuture;
  List<Meal> _allMeals = [];
  List<Meal> _displayedMeals = [];
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _mealsFuture = ApiService().fetchMealsByCategory(widget.categoryName);
    _searchController.addListener(_filterMeals);
  }

  void _filterMeals() {
    final query = _searchController.text.toLowerCase();
    setState(() {
      _displayedMeals = _allMeals
          .where((meal) => meal.strMeal.toLowerCase().contains(query))
          .toList();
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.categoryName),
        backgroundColor: Theme.of(context).primaryColor,
        foregroundColor: Colors.white,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _searchController,
              decoration: const InputDecoration(
                labelText: 'Пребарај јадења во категоријата...',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.search),
              ),
            ),
          ),
          Expanded(
            child: FutureBuilder<List<Meal>>(
              future: _mealsFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Грешка: ${snapshot.error}'));
                } else if (snapshot.hasData) {
                  if (_allMeals.isEmpty && snapshot.data!.isNotEmpty) {
                    _allMeals = snapshot.data!;
                    _displayedMeals = _allMeals;
                    if (_searchController.text.isNotEmpty) {
                      WidgetsBinding.instance
                          .addPostFrameCallback((_) => _filterMeals());
                    }
                  } else if (_allMeals.isEmpty && snapshot.data!.isEmpty) {
                    return Center(
                        child: Text(
                            'Нема пронајдено јадења во ${widget.categoryName}.'));
                  }

                  if (_displayedMeals.isEmpty) {
                    return Center(
                        child: Text(
                            'Нема пронајдено јадења според пребарувањето во ${widget.categoryName}.'));
                  }

                  return GridView.builder(
                    padding: const EdgeInsets.all(8.0),
                    gridDelegate:
                    const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 10,
                      mainAxisSpacing: 10,
                      childAspectRatio: 0.75,
                    ),
                    itemCount: _displayedMeals.length,
                    itemBuilder: (context, index) {
                      final meal = _displayedMeals[index];
                      return MealGridItem(
                        meal: meal,
                        firebaseService: widget.firebaseService,
                      );
                    },
                  );
                } else {
                  return const Center(child: Text('Нема јадења.'));
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}