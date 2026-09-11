import '../models/product_list_result.dart';
import '../services/product_api.dart';
import '../models/product.dart';
class ProductRepository{
  ProductRepository({ProductApi? api}) : _api = api ?? ProductApi();
  final ProductApi _api;
  Future<ProductListResult> getProducts({int skip = 0, int limit = 20}){
    return _api.fetchProducts(skip: skip, limit: limit);
  }
  Future<Product> getProduct(int id) => _api.fetchProductById(id);
}