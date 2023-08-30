import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:food_delivery_app/core/model/models.dart';
import 'package:food_delivery_app/core/model/resturant_model.dart';
import 'package:food_delivery_app/routing/router.dart';
import 'package:food_delivery_app/ui/pages/entry/more_pages/chat/firestore_constants.dart';

class HomeController extends ChangeNotifier {
  List<FoodItem>? foodList;

  void navigateToDetailsPage(BuildContext context, ProductModel productModel) {
    Navigator.pushNamed(context, RouteGenerator.detailsPage,
        arguments: productModel);
  }

  Future<List<FoodItem>> fetchFoodItemsFromFirestore() async {
    try {
      final QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection(FirestoreConstants.latest_offers)
          .get();

      final restaurants = querySnapshot.docs
          .map(
            (doc) => FoodItem.fromFirestore(doc.data() as Map<String, dynamic>),
          )
          .toList();

      foodList = restaurants;
      notifyListeners();
      return restaurants;
    } catch (error) {
      print("Error getting restaurants: $error");
      rethrow; // Rethrow the error for better error handling
    }
  }

  Stream<QuerySnapshot> getMostPopularFoodStream() {
    return FirebaseFirestore.instance
        .collection('most_popular_food')
        .snapshots();
  }

  String getTitle(DocumentSnapshot doc) {
    return doc['name'];
  }

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

class DetailsScreenArguments {
  final String title;
  final String rating;
  final String description;
  final String imagePath;
  final String ratingCount;
  final String prices;

  DetailsScreenArguments({
    required this.title,
    required this.rating,
    required this.description,
    required this.imagePath,
    required this.ratingCount,
    required this.prices,
  });
}
