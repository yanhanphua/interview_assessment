import 'package:flutter/material.dart';
import '../../models/product.dart';

class ProductCard extends StatelessWidget {
  const ProductCard({super.key, required this.product});
  final Product product;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading:ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: product.thumbnail.isEmpty
            ? const SizedBox(
            width:56,
            height:56,
            child: Icon(Icons.image_not_supported_outlined),
        )
            : Image.network(
          product.thumbnail,
          width:56,
          height:56,
          fit: BoxFit.cover,
          errorBuilder: (context,error,stackTrace) => const SizedBox(
            width: 56,
            height: 56,
            child:  Icon(Icons.image_not_supported_outlined),
          )
        )
      ),title: Text(product.title, maxLines: 1, overflow: TextOverflow.ellipsis,),
      subtitle: Text('\$${product.price.toStringAsFixed(2)}'),
    );
  }
}
