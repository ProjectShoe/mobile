class ProductModel {
  final String id;
  final String name;
  final String description;
  final double price;
  final int quantity;
  // final bool isAvailable;
  final String image;

  ProductModel(
      {required this.id,
      required this.name,
      required this.description,
      required this.price,
      required this.quantity,
      required this.image
      // required this.isAvailable,
      });

  factory ProductModel.fromJson(Map<String, dynamic> json) {
    return ProductModel(
      id: json['_id'],
      name: json['name'],
      description: json['description'],
      price: (json['price'] as num).toDouble(),
      quantity: json['quantity'],
      image: json['image'],
      // isAvailable: json['isAvailable'],
    );
  }
}
