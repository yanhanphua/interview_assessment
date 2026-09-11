import 'package:flutter/foundation.dart';
import '../core/errors/api_exception.dart';
import '../models/product.dart';
import '../repositories/product_repository.dart';

enum ProductDetailStatus { loading, error, success }

class ProductDetailViewModel extends ChangeNotifier {
  ProductDetailViewModel({
    required ProductRepository repository,
    required int productId,
  }) :  _repository = repository,
        _productId = productId;
  final ProductRepository _repository;
  final int _productId;
  ProductDetailStatus status = ProductDetailStatus.loading;
  Product? product;
  String? errorMessage;

  Future<void> loadProduct() async {
    status = ProductDetailStatus.loading;
    errorMessage = null;
    notifyListeners();

    try {
      product = await _repository.getProduct(_productId);
      status = ProductDetailStatus.success;
    } catch (e) {
      errorMessage = e is ApiException ? e.message : 'Something went wrong. Please try again.';
      status = ProductDetailStatus.error;
    }
    notifyListeners();
  }
}
