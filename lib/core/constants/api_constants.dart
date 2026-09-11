class ApiConstants{
  const ApiConstants._();
  static const String baseUrl = 'https://dummyjson.com';
  static const String products = '/products';
  static const String productSearch = '/products/search';
  static String productById(int id) => '/products/$id';
}