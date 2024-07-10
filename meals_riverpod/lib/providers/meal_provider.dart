import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:meals/data/dummy_data.dart';

final meal_provider = Provider((ref) {
  return dummyMeals1;
});
