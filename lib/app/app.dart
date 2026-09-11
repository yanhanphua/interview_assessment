import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../repositories/product_repository.dart';
import '../views/product_list_screen.dart';

class App extends StatelessWidget {
  const App({super.key, required this.productRepository});
  final ProductRepository productRepository;
  @override
  Widget build(BuildContext context) {
    return Provider<ProductRepository>.value(
      value: productRepository,
      child: MaterialApp(
        title: 'Products',
        theme: ThemeData(colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple)),
        home: const ProductListScreen(),
      ),
    );
  }
}
