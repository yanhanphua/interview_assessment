import 'package:flutter/foundation.dart';
import '../models/product.dart';
import '../repositories/product_repository.dart';

class ProductListViewModel extends ChangeNotifier{
  ProductListViewModel({required ProductRepository repository})
      : _repository = repository;
  final ProductRepository _repository;
  static const _pageSize = 20;
  List<Product> products = const[];
  bool isLoadingMore = false;
  int _skip = 0;
  int _total = 0;
  bool get hasMore => _skip < _total;

  Future<void> loadInitial() async {
    final result = await _repository.getProducts();
    products = result.products;
    _skip = result.skip + result.products.length;
    _total = result.total;
    notifyListeners();
  }
  Future<void> loadNextPage() async {
    if(isLoadingMore || !hasMore) return;
    isLoadingMore = true;
    notifyListeners();
    final result = await _repository.getProducts(skip:_skip, limit: _pageSize);
    products = [...products,...result.products];
    _skip = result.skip + result.products.length;
    _total = result.total;
    isLoadingMore = false;
    notifyListeners();
  }
}