class Shop {
  final String id;
  final String name;
  final String image;
  final String address;
  final double rating;
  final String phone;
  final String email;

  Shop({
    required this.id,
    required this.name,
    required this.image,
    required this.address,
    required this.rating,
    required this.phone,
    required this.email,
  });

  factory Shop.fromJson(Map<String, dynamic> json) {
    return Shop(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      image: json['image'] ?? '',
      address: json['address'] ?? '',
      rating: (json['rating'] ?? 0.0).toDouble(),
      phone: json['phone'] ?? '',
      email: json['email'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'image': image,
      'address': address,
      'rating': rating,
      'phone': phone,
      'email': email,
    };
  }
}