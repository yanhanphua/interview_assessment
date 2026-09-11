import 'package:flutter/foundation.dart';
import '../models/product.dart';
import '../repositories/product_repository.dart';

class ProductDetailViewModel extends ChangeNotifier {
  ProductDetailViewModel({
    required ProductRepository repository,
    required int productId,
  }) :  _repository = repository,
        _productId = productId;
  final ProductRepository _repository;
  final int _productId;
  Product? product;
  Future<void> loadProduct() async {
    product = await _repository.getProduct(_productId);
    notifyListeners();
  }
}
