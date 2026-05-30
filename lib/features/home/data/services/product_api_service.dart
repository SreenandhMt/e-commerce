import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../../../core/constants/api_constants.dart';

abstract interface class ProductApiService {
  Future<List<dynamic>> fetchProducts();
}

class ProductApiServiceImpl implements ProductApiService {
  final http.Client _client;

  ProductApiServiceImpl({http.Client? client}) : _client = client ?? http.Client();

  @override
  Future<List<dynamic>> fetchProducts() async {
    final uri = Uri.parse('${ApiConstants.baseUrl}${ApiConstants.products}');
    try {
      final response = await _client.get(uri).timeout(const Duration(seconds: 10));
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data is List) {
          return data;
        } else {
          throw Exception('Invalid server response: Expected a list of products.');
        }
      } else {
        throw Exception('Server error: code ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Network error: Failed to fetch products ($e)');
    }
  }
}
