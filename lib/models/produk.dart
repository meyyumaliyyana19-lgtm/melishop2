class Produk {
  final String id;
  final String name;
  final double price;
  final String description;
  final String imageUrl;

  Produk({
    required this.id,
    required this.name,
    required this.price,
    required this.description,
    required this.imageUrl,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'price': price,
      'description': description,
      'imageUrl': imageUrl,
    };
  }

  factory Produk.fromMap(Map<String, dynamic> map) {
    return Produk(
      id: map['id'] ?? '',
      name: map['name'] ?? '',
      price: (map['price'] as num?)?.toDouble() ?? 0.0,
      description: map['description'] ?? '',
      imageUrl: map['imageUrl'] ?? '',
    );
  }
}