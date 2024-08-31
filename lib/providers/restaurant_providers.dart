import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/restaurant.dart';
// import '../models/restaurant.dart';

final restaurantProvider =
    StateNotifierProvider<RestaurantNotifier, List<Restaurant>>((ref) {
  return RestaurantNotifier();
});

class RestaurantNotifier extends StateNotifier<List<Restaurant>> {
  RestaurantNotifier() : super([]) {
    _loadRestaurants();
  }

  Future<void> _loadRestaurants() async {
    final String response =
        await rootBundle.loadString('assets/restaurants.json');
    final List<dynamic> data = jsonDecode(response);

    state = data.map((restaurant) => Restaurant.fromJson(restaurant)).toList();
  }

  void filterRestaurants(String query) {
    if (query.isEmpty) {
      _loadRestaurants();
    } else {
      state = state
          .where((restaurant) =>
              restaurant.name.toLowerCase().contains(query.toLowerCase()))
          .toList();
    }
  }
}
