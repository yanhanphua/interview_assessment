import 'package:flutter/material.dart';
import 'app/app.dart';
import 'repositories/product_repository.dart';
void main() {
  runApp(App(productRepository: ProductRepository(),));
}
