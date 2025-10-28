class Product {
  final int? id;
  final String name;
  final int quantity;
  final double price;
  final String? imagePath;
  Product({
    this.id,
    required this.name,
    required this.quantity,
    required this.price,
    this.imagePath,
  });

  // Convert a Product object into a Map for the database
  Map<String, dynamic> toMap() {
    return {
      if (id != null) 'id': id,
      'name': name,
      'quantity': quantity,
      'price': price,
      // image is stored as a string
      'imagePath': imagePath,
    };
  }

  // Convert a Map from the database into a Product object
  factory Product.fromMap(Map<String, dynamic> map) {
    return Product(
      id: map['id'] as int?,
      name: map['name'] as String,
      quantity: map['quantity'] as int,
      price: map['price'] as double,
      imagePath: map['imagePath'] as String?,
    );
  }

  // Helper for creating an updated instance
  Product copyWith({
    int? id,
    String? name,
    int? quantity,
    double? price,
    String? imagePath,
  }) {
    return Product(
      id: id ?? this.id,
      name: name ?? this.name,
      quantity: quantity ?? this.quantity,
      price: price ?? this.price,
      imagePath: imagePath ?? this.imagePath,
    );
  }
}
