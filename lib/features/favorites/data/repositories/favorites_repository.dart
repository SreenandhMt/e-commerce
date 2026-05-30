import '../../../../core/storage/hive_service.dart';
import '../../../home/data/models/product_model.dart';

abstract interface class FavoritesRepository {
  List<int> getFavoriteIds();
  Future<void> toggleFavorite(int productId);
  List<ProductModel> getFavoriteProducts();
}

class FavoritesRepositoryImpl implements FavoritesRepository {
  @override
  List<int> getFavoriteIds() {
    return HiveService.getFavoriteIds();
  }

  @override
  Future<void> toggleFavorite(int productId) async {
    final favorites = HiveService.getFavoriteIds();
    if (favorites.contains(productId)) {
      favorites.remove(productId);
    } else {
      favorites.add(productId);
    }
    await HiveService.saveFavoriteIds(favorites);
  }

  @override
  List<ProductModel> getFavoriteProducts() {
    final cached = HiveService.getCachedProducts();
    if (cached == null) return [];
    final favorites = HiveService.getFavoriteIds();
    try {
      return cached
          .map((json) => ProductModel.fromJson(json as Map<String, dynamic>))
          .where((product) => favorites.contains(product.id))
          .toList();
    } catch (_) {
      return [];
    }
  }
}
