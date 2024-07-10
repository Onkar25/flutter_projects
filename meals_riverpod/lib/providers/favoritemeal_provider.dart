import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:meals/models/meal.dart';

class FavoritemealProvider extends StateNotifier<List<Meal>> {
  FavoritemealProvider() : super([]);

  bool toggleFavoriteMealStatus(Meal meal) {
    final mealsFavorite = state.contains(meal);

    if (mealsFavorite) {
      state = state.where((m) => m.id != meal.id).toList();
      return false;
    } else {
      state = [...state, meal];
      return true;
    }
  }
}

final favoriteMealProvider =
    StateNotifierProvider<FavoritemealProvider, List<Meal>>((ref) {
  return FavoritemealProvider();
});
