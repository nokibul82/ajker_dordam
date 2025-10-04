class Product {
  final String id;
  final String title;
  final String description;
  final double price;
  final double? oldPrice;
  final List<String> images;
  final String category;
  final String brand;
  final double rating;
  final int reviewCount;
  final bool isFeatured;
  final bool isPopular;
  final String shopId; // Add this field
  final DateTime createdAt;

  Product({
    required this.id,
    required this.title,
    required this.description,
    required this.price,
    this.oldPrice,
    required this.images,
    required this.category,
    required this.brand,
    required this.rating,
    required this.reviewCount,
    required this.isFeatured,
    required this.isPopular,
    required this.shopId, // Add this parameter
    required this.createdAt,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'] ?? '',
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      price: (json['price'] ?? 0.0).toDouble(),
      oldPrice: (json['oldPrice'] ?? 0.0).toDouble(),
      images: List<String>.from(json['images'] ?? []),
      category: json['category'] ?? '',
      brand: json['brand'] ?? '',
      rating: (json['rating'] ?? 0.0).toDouble(),
      reviewCount: json['reviewCount'] ?? 0,
      isFeatured: json['isFeatured'] ?? false,
      isPopular: json['isPopular'] ?? false,
      shopId: json['shopId'] ?? '', // Add this line
      createdAt: DateTime.parse(json['createdAt'] ?? DateTime.now().toString()),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'price': price,
      'oldPrice': oldPrice,
      'images': images,
      'category': category,
      'brand': brand,
      'rating': rating,
      'reviewCount': reviewCount,
      'isFeatured': isFeatured,
      'isPopular': isPopular,
      'shopId': shopId, // Add this line
      'createdAt': createdAt.toIso8601String(),
    };
  }
}