import 'dart:convert';
import 'package:hive_ce_flutter/hive_ce_flutter.dart';

import 'hive_boxes.dart';
import 'hive_keys.dart';

class HiveService {
  // Initialize Hive and open the standard cache box
  static Future<void> init() async {
    await Hive.initFlutter();
    await Hive.openBox(HiveBoxes.cacheBox);
  }

  static Box get _cacheBox => Hive.box(HiveBoxes.cacheBox);

  // Store the raw product list as a JSON string
  static Future<void> cacheProducts(List<dynamic> rawJsonList) async {
    final jsonString = jsonEncode(rawJsonList);
    await _cacheBox.put(HiveKeys.productsCache, jsonString);
  }

  // Retrieve cached product list
  static List<dynamic>? getCachedProducts() {
    final jsonString = _cacheBox.get(HiveKeys.productsCache) as String?;
    if (jsonString == null) return null;
    try {
      return jsonDecode(jsonString) as List<dynamic>;
    } catch (_) {
      return null;
    }
  }

  // Clear cache helper
  static Future<void> clearCache() async {
    await _cacheBox.delete(HiveKeys.productsCache);
  }

  // Save the list of favorite product IDs
  static Future<void> saveFavoriteIds(List<int> ids) async {
    await _cacheBox.put(HiveKeys.favorites, ids);
  }

  // Retrieve cached favorite product IDs
  static List<int> getFavoriteIds() {
    final ids = _cacheBox.get(HiveKeys.favorites);
    if (ids is List) {
      return ids.cast<int>();
    }
    return [];
  }
}
