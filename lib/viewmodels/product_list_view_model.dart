import 'package:flutter/foundation.dart';
import '../models/product.dart';
import '../repositories/product_repository.dart';

class ProductListViewModel extends ChangeNotifier{
  ProductListViewModel({required ProductRepository repository})
      : _repository = repository;
  final ProductRepository _repository;
  List<Product> products = const[];
  Future<void> loadInitial() async {
    final result = await _repository.getProducts();
    products = result.products;
    notifyListeners();
  }
}