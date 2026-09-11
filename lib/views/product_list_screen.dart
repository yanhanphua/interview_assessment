import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../app/app_routes.dart';
import '../repositories/product_repository.dart';
import '../viewmodels/product_list_view_model.dart';
import 'widgets/error_view.dart';
import 'widgets/product_card.dart';

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
      body: _buildBody(context, viewModel),
    );
  }
  Widget _buildBody(BuildContext context, ProductListViewModel viewModel) {
    switch (viewModel.status) {
      case ProductListStatus.loading:
        return const Center(child: CircularProgressIndicator());
      case ProductListStatus.error:
        return ErrorView(
          message: viewModel.errorMessage ?? 'Something went wrong.',
          onRetry: viewModel.retry,
        );
      case ProductListStatus.empty:
        return const Center(child: Text('No products found.'));
      case ProductListStatus.success:
        final showFooter = viewModel.isLoadingMore || viewModel.pageError != null;
        return ListView.builder(
          controller: _scrollController,
          itemCount: viewModel.products.length + (showFooter ? 1 : 0),
          itemBuilder: (context, index) {
            if (index >= viewModel.products.length) {
              if (viewModel.pageError != null) {
                return InlineRetry(message: viewModel.pageError!, onRetry: viewModel.retry);
              }
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
        );
    }
  }
}
