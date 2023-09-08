import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:food_delivery_app/core/model/models.dart';
import 'package:food_delivery_app/core/model/resturant_model.dart';
import 'package:food_delivery_app/routing/router.dart';

class HomeController extends ChangeNotifier {
  List<FoodItem>? foodList;

  void navigateToDetailsPage(BuildContext context, ProductModel productModel) {
    Navigator.pushNamed(context, RouteGenerator.detailsPage,
        arguments: productModel);
  }

  Stream<QuerySnapshot> getMostPopularFoodStream() {
    return FirebaseFirestore.instance
        .collection('most_popular_food')
        .limit(2)
        .snapshots();
  }

  Stream<QuerySnapshot> getAllPopularFoodStream() {
    return FirebaseFirestore.instance
        .collection('most_popular_food')
        .snapshots();
  }

  String getTitle(DocumentSnapshot doc) {
    return doc['name'];
  }

  void fetchFoodItemsFromFirestore2() {}

  String getRating(DocumentSnapshot doc) {
    return doc['rating'].toString();
  }

  String getDescription(DocumentSnapshot doc) {
    return doc['description'];
  }

  String getImagePath(DocumentSnapshot doc) {
    return doc['imagePath'];
  }

  String getRatingCount(DocumentSnapshot doc) {
    return doc['ratingCount'].toString();
  }

  String getPrice(DocumentSnapshot doc) {
    return doc['price'].toString();
  }
}
