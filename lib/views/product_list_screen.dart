import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../repositories/product_repository.dart';
import '../viewmodels/product_list_view_model.dart';
import 'widgets/product_card.dart';

class ProductListScreen extends StatelessWidget {
  const ProductListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
        create: (context)=> ProductListViewModel(
          repository:context.read<ProductRepository>(),
        )..loadInitial(),
        child:const _ProductListBody());
  }
}
class _ProductListBody extends StatelessWidget{
  const _ProductListBody();
  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<ProductListViewModel>();
    return Scaffold(
      appBar: AppBar(title: const Text('Products')),
      body: ListView.builder(
        itemCount: viewModel.products.length,
        itemBuilder: (context, index) => ProductCard(product: viewModel.products[index]),
      ),
    );
  }
}