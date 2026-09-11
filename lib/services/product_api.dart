import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import '../core/constants/api_constants.dart';
import '../core/errors/api_exception.dart';
import '../models/product_list_result.dart';

class ProductApi {
  ProductApi({http.Client? client, String? baseUrl})
      : _client = client ?? http.Client(),
        _baseUrl = baseUrl ?? ApiConstants.baseUrl;
  final http.Client _client;
  final String _baseUrl;
  Future<ProductListResult> fetchProducts({int skip = 0, limit = 20}) async{
    final uri = Uri.parse('$_baseUrl${ApiConstants.products}').replace(
      queryParameters: {'skip': '$skip', 'limit': '$limit'},
    );
    final json = await _getJson(uri) as Map<String, dynamic>;
    return ProductListResult.fromJson(json);
  }
  Future<dynamic> _getJson(Uri uri)async{
    try{
      final response = await _client.get(uri);
      if(response.statusCode != 200){
        throw ApiException('Request to $uri failed with status ${response.statusCode}', statusCode: response.statusCode);
      }
      return jsonDecode(response.body);
    }on ApiException {
      rethrow;
    } on SocketException catch (e) {
      throw ApiException('No internet connection: ${e.message}');
    } on http.ClientException catch (e) {
      throw ApiException('Network error: ${e.message}');
    } on FormatException catch (e) {
      throw ApiException('Invalid response from server: ${e.message}');
    } catch (e) {
      throw ApiException('Unexpected error while calling $uri: $e');
    }
  }
}
