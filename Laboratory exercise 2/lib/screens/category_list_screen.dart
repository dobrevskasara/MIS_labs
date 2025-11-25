import 'package:flutter/material.dart';
import '../models/category.dart';
import '../services/api_service.dart';
import '../widgets/category_card.dart';
import 'random_meal_screen.dart';

class CategoryListScreen extends StatefulWidget {
  const CategoryListScreen({super.key});

  @override
  State<CategoryListScreen> createState() => _CategoryListScreenState();
}

class _CategoryListScreenState extends State<CategoryListScreen> {
  late Future<List<Category>> _categoriesFuture;
  List<Category> _allCategories = [];
  List<Category> _filteredCategories = [];
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();

    _categoriesFuture = ApiService().fetchCategories();

    _searchController.addListener(_filterCategories);
  }

  void _filterCategories() {
    final query = _searchController.text.toLowerCase();
    setState(() {
      _filteredCategories = _allCategories.where((category) {
        return category.strCategory.toLowerCase().contains(query);
      }).toList();
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
        title: const Text('MealDB Категории'),
        backgroundColor: Theme.of(context).primaryColor,
        foregroundColor: Colors.white,
        actions: [

          IconButton(
            icon: const Icon(Icons.shuffle),
            tooltip: 'Случаен Рецепт',
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const RandomMealScreen()),
              );
            },
          ),
        ],
      ),
      body: Column(
        children: [

          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _searchController,
              decoration: const InputDecoration(
                labelText: 'Пребарај категории...',
                border: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(10))),
                prefixIcon: Icon(Icons.search),
              ),
            ),
          ),

          Expanded(
            child: FutureBuilder<List<Category>>(
              future: _categoriesFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Грешка: ${snapshot.error}'));
                } else if (snapshot.hasData) {

                  if (_allCategories.isEmpty) {
                    _allCategories = snapshot.data!;
                    _filteredCategories = _allCategories;

                    if (_searchController.text.isNotEmpty) {
                      WidgetsBinding.instance.addPostFrameCallback((_) => _filterCategories());
                    }
                  }

                  if (_filteredCategories.isEmpty) {
                    return const Center(child: Text('Нема пронајдени категории според пребарувањето.'));
                  }


                  return ListView.builder(
                    itemCount: _filteredCategories.length,
                    itemBuilder: (context, index) {
                      final category = _filteredCategories[index];
                      return CategoryCard(category: category);
                    },
                  );
                } else {
                  return const Center(child: Text('Нема пронајдени категории.'));
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}