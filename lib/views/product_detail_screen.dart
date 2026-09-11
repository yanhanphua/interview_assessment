import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/product.dart';
import '../repositories/product_repository.dart';
import '../viewmodels/product_detail_view_model.dart';

class ProductDetailScreen extends StatelessWidget {
  const ProductDetailScreen({super.key, required this.productId});
  final int productId;
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
        create: (context)=> ProductDetailViewModel(
          repository:context.read<ProductRepository>(),
          productId: productId,
        )..loadProduct(),
        child:const _ProductDetailBody()
    );
  }
}
class _ProductDetailBody extends StatelessWidget {
  const _ProductDetailBody();

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<ProductDetailViewModel>();
    final product = viewModel.product;

    return Scaffold(
      appBar: AppBar(title: Text(product?.title ?? 'Product')),
      body: product == null
          ? const Center(child: CircularProgressIndicator())
          : _ProductDetailContent(product: product),
    );
  }
}
class _ProductDetailContent extends StatelessWidget {
  const _ProductDetailContent({required this.product});

  final Product product;

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        if (product.images.isNotEmpty)
          SizedBox(
            height: 220,
            child: PageView.builder(
              itemCount: product.images.length,
              itemBuilder: (context, index) => ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.network(
                  product.images[index],
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) =>
                  const Center(child: Icon(Icons.image_not_supported_outlined, size: 48)),
                ),
              ),
            ),
          ),
        const SizedBox(height: 16),
        Text(product.title, style: Theme.of(context).textTheme.headlineSmall),
        const SizedBox(height: 8),
        Row(
          children: [
            Text(
              '\$${product.price.toStringAsFixed(2)}',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(width: 16),
            const Icon(Icons.star, color: Colors.amber, size: 20),
            const SizedBox(width: 4),
            Text(product.rating.toStringAsFixed(2)),
          ],
        ),
        const SizedBox(height: 16),
        Text(product.description, style: Theme.of(context).textTheme.bodyMedium),
      ],
    );
  }
}
