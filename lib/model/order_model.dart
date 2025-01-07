import 'package:shoes_store/model/product_model.dart';

class OrderProduct {
  final String id;
  final int quantity;
  final ProductModel? productModel;
  OrderProduct(
      {required this.id, required this.quantity, required this.productModel});

  factory OrderProduct.fromJson(Map<String, dynamic> json) {
    return OrderProduct(
        id: json['_id'],
        quantity: json['quantity'],
        productModel: json['productId'] != null
            ? ProductModel.fromJson(json['productId'])
            : null);
  }
}

class OrderModel {
  final List<OrderProduct> products;
  final int totalPrice;
  final bool status;
  final String id;
  final String time;
  OrderModel({
    required this.products,
    required this.totalPrice,
    required this.status,
    required this.id,
    required this.time,
  });

  factory OrderModel.fromJson(Map<String, dynamic> json) {
    var productsList = (json['products'] as List)
        .map((e) => OrderProduct.fromJson(e))
        .toList();
    return OrderModel(
        products: productsList,
        totalPrice: json['totalPrice'],
        status: json['status'],
        id: json['_id'],
        time: json['createdAt']);
  }
}
