import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/category.dart';
import '../models/meal.dart';
import '../models/meal_detail.dart';

class ApiService {

  static const String _baseUrl = 'https://www.themealdb.com/api/json/v1/1';


  Future<List<Category>> fetchCategories() async {
    final url = '$_baseUrl/categories.php';
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final List<dynamic> categoriesJson = (data['categories'] is List) ? data['categories'] : [];

      return categoriesJson
          .map((json) => Category.fromJson(json as Map<String, dynamic>))
          .toList();
    } else {
      throw Exception('Failed to load categories. Status Code: ${response.statusCode}');
    }
  }


  Future<List<Meal>> fetchMealsByCategory(String categoryName) async {
    final encodedCategory = Uri.encodeComponent(categoryName);
    final url = '$_baseUrl/filter.php?c=$encodedCategory';

    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final List<dynamic>? mealsJson = data['meals'] is List ? data['meals'] : null;

      if (mealsJson == null) {
        return [];
      }

      return mealsJson
          .map((json) => Meal.fromJson(json as Map<String, dynamic>))
          .toList();
    } else {
      throw Exception('Failed to load meals for category $categoryName. Status Code: ${response.statusCode}');
    }
  }


  Future<MealDetail> fetchMealDetail(String idMeal) async {
    final url = '$_baseUrl/lookup.php?i=$idMeal';
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final List<dynamic>? mealsJson = data['meals'] is List ? data['meals'] : null;

      if (mealsJson == null || mealsJson.isEmpty || mealsJson[0] == null) {
        throw Exception('Meal with ID $idMeal not found.');
      }

      return MealDetail.fromJson(mealsJson[0] as Map<String, dynamic>);
    } else {
      throw Exception('Failed to load meal detail for ID $idMeal. Status Code: ${response.statusCode}');
    }
  }


  Future<MealDetail> fetchRandomMeal() async {
    final url = '$_baseUrl/random.php';
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final List<dynamic>? mealsJson = data['meals'] is List ? data['meals'] : null;

      if (mealsJson == null || mealsJson.isEmpty || mealsJson[0] == null) {
        throw Exception('Random meal not found.');
      }

      return MealDetail.fromJson(mealsJson[0] as Map<String, dynamic>);
    } else {
      throw Exception('Failed to load random meal. Status Code: ${response.statusCode}');
    }
  }
}