import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:meals/providers/meal_provider.dart';

enum Filters { glutenFree, lactosFree, vegeterian, vegan }

class FilterNotifier extends StateNotifier<Map<Filters, bool>> {
  FilterNotifier()
      : super({
          Filters.glutenFree: false,
          Filters.lactosFree: false,
          Filters.vegan: false,
          Filters.vegeterian: false,
        });

  void setFilters(Map<Filters, bool> mapFilter) {
    state = mapFilter;
  }

  void setFilter(Filters filter, bool isActive) {
    state = {...state, filter: isActive};
  }
}

final filterProvider =
    StateNotifierProvider<FilterNotifier, Map<Filters, bool>>(
  (ref) => FilterNotifier(),
);

final filterMealsProvider = Provider((ref) {
  final meals = ref.watch(meal_provider);
  final activeFilter = ref.watch(filterProvider);
  return meals.where((meal) {
    if (activeFilter[Filters.glutenFree]! && !meal.isGlutenFree) {
      return false;
    }
    if (activeFilter[Filters.lactosFree]! && !meal.isLactoseFree) {
      return false;
    }
    if (activeFilter[Filters.vegan]! && !meal.isVegan) {
      return false;
    }
    if (activeFilter[Filters.vegeterian]! && !meal.isVegetarian) {
      return false;
    }
    return true;
  }).toList();
});
