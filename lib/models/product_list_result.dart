import 'product.dart';

class ProductListResult{
  const ProductListResult({
    required this.products,
    required this.total,
    required this.skip,
    required this.limit,
  });
  final List<Product> products;
  final int total;
  final int skip;
  final int limit;
  factory ProductListResult.fromJson( Map<String, dynamic> json){
    return ProductListResult(
      products:(json['products'] as List<dynamic>? ?? const [])
          .map((product)=> Product.fromJson(product as Map<String, dynamic>))
          .toList(),
      total: json['total'] as int? ?? 0,
      skip: json['skip'] as int? ?? 0,
      limit: json['limit'] as int? ?? 0,
    );
  }
  bool get hasMore=> skip + products.length<total;
}