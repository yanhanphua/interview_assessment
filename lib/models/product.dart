class Product{
  const Product({
    required this.id,
    required this.title,
    required this.thumbnail,
    required this.price,
    required this.description,
    required this.rating,
    required this.images,
  });
  final int id;
  final String title;
  final String thumbnail;
  final double price;
  final String description;
  final double rating;
  final List<String> images;
  factory Product.fromJson(Map<String, dynamic> json){
    return Product(
      id: json['id'] as int,
      title: json['title'] as String ?? '',
      thumbnail: json['thumbnail'] as String ?? '',
      price: (json['price'] as num?)?.toDouble() ?? 0.0,
      description: json['description'] as String ?? '',
      rating: (json['rating'] as num?)?.toDouble() ?? 0.0,
      images: (json['images'] as List<dynamic>? ?? const [])
          .map((image) => image as String)
          .toList(),
    );
  }
}