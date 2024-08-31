// lib/providers/restaurant_provider.dart
import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;

import '../models/restaurant.dart';

final restaurantProvider =
    StateNotifierProvider<RestaurantNotifier, List<Restaurant>>((ref) {
  return RestaurantNotifier();
});

class RestaurantNotifier extends StateNotifier<List<Restaurant>> {
  RestaurantNotifier() : super([]) {
    _loadRestaurants();
  }

  Future<void> _loadRestaurants() async {
    const url =
        'https://drive.google.com/uc?export=download&id=1uN_gk2oJ5F4JMAsbjThTmER3LffulsZ2';
    try {
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        state =
            data.map((restaurant) => Restaurant.fromJson(restaurant)).toList();
      } else {
        throw Exception('Failed to load restaurants');
      }
    } catch (e) {
      print(e);
      throw Exception('Failed to load restaurants');
    }
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
