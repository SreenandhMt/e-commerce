import '../../../../core/storage/hive_service.dart';
import '../models/product_model.dart';
import '../services/product_api_service.dart';

abstract interface class ProductRepository {
  Future<List<ProductModel>> getProducts();
}

class ProductRepositoryImpl implements ProductRepository {
  final ProductApiService _apiService;

  ProductRepositoryImpl({required ProductApiService apiService}) : _apiService = apiService;

  @override
  Future<List<ProductModel>> getProducts() async {
    try {
      // Attempt to load from public network API
      final rawList = await _apiService.fetchProducts();

      // Cache fresh data locally using HiveService
      await HiveService.cacheProducts(rawList);

      // Map dynamic lists into domain models
      return rawList
          .map((json) => ProductModel.fromJson(json as Map<String, dynamic>))
          .toList();
    } catch (e) {
      // Offline fallback: Check Hive cache
      final cachedList = HiveService.getCachedProducts();
      if (cachedList != null && cachedList.isNotEmpty) {
        return cachedList
            .map((json) => ProductModel.fromJson(json as Map<String, dynamic>))
            .toList();
      }

      // If no internet and no cache exists, throw original error
      throw Exception(e.toString().replaceFirst('Exception: ', ''));
    }
  }
}
