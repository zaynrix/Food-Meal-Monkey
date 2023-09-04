import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:food_delivery_app/core/model/models.dart';

class OrderModel {
  OrderModel(
      {
      this.id = "null id",
      required this.createdAt,
      required this.status,
      required this.location,
      required this.products});

  final String id;
  final String createdAt;
  final List<ProductModel> products;
  final String location;
  final String status;

  factory OrderModel.fromJson(Map<String, dynamic> json) {
    final List<dynamic> productJsonList = json['products'];
    final List<ProductModel> productList = productJsonList
        .map((productJson) => ProductModel.fromJson(productJson))
        .toList();

    return OrderModel(
      id: json['id'],
      createdAt: json['createdAt'],
      status: json['status'],
      location: json['location'],
      products: productList,
    );
  }

  factory OrderModel.fromDocument(DocumentSnapshot doc) {
    return OrderModel(
        id: doc["id"],
        createdAt: doc["createdAt"],
        status: doc["status"],
        location: doc["location"],
        products: doc["products"]);
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'createdAt': createdAt,
      'status': status,
      'location': location,
      'products': products.map((product) => product.toJson()).toList(),
    };
  }
}
