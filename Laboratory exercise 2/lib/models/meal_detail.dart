class MealDetail {
  final String idMeal;
  final String strMeal;
  final String strMealThumb;
  final String strInstructions;
  final String? strYoutube;
  final List<String> ingredients;
  final List<String> measures;

  MealDetail({
    required this.idMeal,
    required this.strMeal,
    required this.strMealThumb,
    required this.strInstructions,
    this.strYoutube,
    required this.ingredients,
    required this.measures,
  });

  factory MealDetail.fromJson(Map<String, dynamic> json) {
    List<String> ingredients = [];
    List<String> measures = [];

    for (int i = 1; i <= 20; i++) {
      final ingredient = json['strIngredient$i'];
      final measure = json['strMeasure$i'];

      if (ingredient != null && ingredient.isNotEmpty) {
        ingredients.add(ingredient);
        measures.add(measure ?? '');
      }
    }

    return MealDetail(
      idMeal: json['idMeal'] as String,
      strMeal: json['strMeal'] as String,
      strMealThumb: json['strMealThumb'] as String,
      strInstructions: json['strInstructions'] as String,
      strYoutube: json['strYoutube'] == null || json['strYoutube']!.isEmpty ? null : json['strYoutube'] as String?,
      ingredients: ingredients,
      measures: measures,
    );
  }
}