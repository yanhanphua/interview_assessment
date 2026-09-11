import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../repositories/product_repository.dart';
import '../viewmodels/product_list_view_model.dart';
import 'widgets/product_card.dart';
import '../app/app_routes.dart';

class ProductListScreen extends StatelessWidget {
  const ProductListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => ProductListViewModel(
        repository: context.read<ProductRepository>(),
      )..loadInitial(),
      child: const _ProductListBody(),
    );
  }
}

class _ProductListBody extends StatefulWidget {
  const _ProductListBody();

  @override
  State<_ProductListBody> createState() => _ProductListBodyState();
}

class _ProductListBodyState extends State<_ProductListBody> {
  final _scrollController = ScrollController();

  static const _loadMoreThreshold = 200.0;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  void _onScroll() {
    final position = _scrollController.position;
    if (position.pixels >= position.maxScrollExtent - _loadMoreThreshold) {
      context.read<ProductListViewModel>().loadNextPage();
    }
  }

  @override
  void dispose() {
    _scrollController
      ..removeListener(_onScroll)
      ..dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<ProductListViewModel>();

    return Scaffold(
      appBar: AppBar(title: const Text('Products')),
      body: ListView.builder(
        controller: _scrollController,
        itemCount: viewModel.products.length + (viewModel.isLoadingMore ? 1 : 0),
        itemBuilder: (context, index) {
          if (index >= viewModel.products.length) {
            return const Padding(
              padding: EdgeInsets.symmetric(vertical: 16),
              child: Center(child: CircularProgressIndicator()),
            );
          }
          final product = viewModel.products[index];
          return ProductCard(
            product: product,
            onTap: () => Navigator.of(context).pushNamed(
              AppRoutes.productDetail,
              arguments: product.id,
            ),
          );
        },
      ),
    );
  }
}