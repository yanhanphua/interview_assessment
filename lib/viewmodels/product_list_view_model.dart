import 'dart:async';
import 'package:flutter/foundation.dart';
import '../models/product.dart';
import '../repositories/product_repository.dart';
import '../core/errors/api_exception.dart';

enum ProductListStatus { loading, error, empty, success }
enum _LastAction { initial, nextPage, search }

class ProductListViewModel extends ChangeNotifier{
  ProductListViewModel({required ProductRepository repository})
      : _repository = repository;
  final ProductRepository _repository;
  static const _pageSize = 20;
  ProductListStatus status = ProductListStatus.loading;
  List<Product> products = const [];
  String? errorMessage;
  bool isLoadingMore = false;
  String? pageError;
  int _skip = 0;
  int _total = 0;
  _LastAction _lastAction = _LastAction.initial;
  String _query = '';
  static const _searchDebounce = Duration(milliseconds: 400);
  bool get hasMore => !isSearching && _skip < _total;
  bool get isSearching => _query.isNotEmpty;
  Timer? _debounceTimer;

  Future<void> loadInitial() async {
    _lastAction = _LastAction.initial;
    status = ProductListStatus.loading;
    errorMessage = null;
    notifyListeners();

    try {
      final result = await _repository.getProducts(skip: 0, limit: _pageSize);
      products = result.products;
      _skip = result.skip + result.products.length;
      _total = result.total;
      status = products.isEmpty ? ProductListStatus.empty : ProductListStatus.success;
    } catch (e) {
      errorMessage = _messageFor(e);
      status = ProductListStatus.error;
    }
    notifyListeners();
  }
  Future<void> loadNextPage() async {
    if (status != ProductListStatus.success) return;
    if (isLoadingMore || !hasMore) return;

    _lastAction = _LastAction.nextPage;
    isLoadingMore = true;
    pageError = null;
    notifyListeners();

    try {
      final result = await _repository.getProducts(skip: _skip, limit: _pageSize);
      products = [...products, ...result.products];
      _skip = result.skip + result.products.length;
      _total = result.total;
    } catch (e) {
      pageError = _messageFor(e);
    } finally {
      isLoadingMore = false;
      notifyListeners();
    }
  }
  void onSearchChanged(String query) {
    _debounceTimer?.cancel();
    final trimmed = query.trim();

    _debounceTimer = Timer(_searchDebounce, () {
      if (trimmed.isEmpty) {
        if (!isSearching) return;
        _query = '';
        loadInitial();
      } else {
        _query = trimmed;
        _runSearch(trimmed);
      }
    });
  }
  Future<void> _runSearch(String query) async {
    _lastAction = _LastAction.search;
    status = ProductListStatus.loading;
    errorMessage = null;
    notifyListeners();

    try {
      final results = await _repository.searchProducts(query);
      if (query != _query) return; // a newer search superseded this one
      products = results;
      status = products.isEmpty ? ProductListStatus.empty : ProductListStatus.success;
    } catch (e) {
      if (query != _query) return;
      errorMessage = _messageFor(e);
      status = ProductListStatus.error;
    }
    notifyListeners();
  }
  Future<void> retry() {
    switch (_lastAction) {
      case _LastAction.initial:
        return loadInitial();
      case _LastAction.nextPage:
        return loadNextPage();
      case _LastAction.search:
        return _runSearch(_query);
    }
  }
  String _messageFor(Object error) {
    return error is ApiException ? error.message : 'Something went wrong. Please try again.';
  }
}