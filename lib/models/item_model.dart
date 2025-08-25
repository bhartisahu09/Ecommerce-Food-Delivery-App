class ItemModel {
  final String id;
  final String name;
  final String description;
  final double price;
  final String imageUrl;
  final int discount;
  final double discountedPrice;

  ItemModel({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.imageUrl,
    required this.discount,
    required this.discountedPrice,
  });

  factory ItemModel.fromMap(Map<String, dynamic> map, String id) {
    final price = (map['price'] ?? 0).toDouble();
    final discount = (map['discount'] ?? 0);
    final discountedPrice = price * (1 - (discount / 100));

    return ItemModel(
      id: id,
      name: map['name'] ?? '',
      description: map['description'] ?? '',
      price: price,
      imageUrl: map['imageUrl'] ?? '',
      discount: discount,
      discountedPrice: discountedPrice,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'description': description,
      'price': price,
      'imageUrl': imageUrl,
      'discount': discount,
      'discountedPrice': discountedPrice,
    };
  }
}
