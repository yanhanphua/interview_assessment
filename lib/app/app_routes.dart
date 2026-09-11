import 'package:flutter/material.dart';
import '../views/product_list_screen.dart';
import '../views/product_detail_screen.dart';

class AppRoutes{
  const AppRoutes._();
  static const String productList = '/';
  static const String productDetail = '/product-detail';
  static Route<dynamic> onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case productDetail:
        final productId = settings.arguments as int;
        return MaterialPageRoute(
          settings: settings,
          builder: (_) => ProductDetailScreen(productId: productId),
        );
      case productList:
      default:
        return MaterialPageRoute(
          settings: settings,
          builder: (_) => const ProductListScreen(),
        );
    }
  }
}