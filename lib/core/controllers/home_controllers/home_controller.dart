import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:food_delivery_app/routing/router.dart';

class DetailsScreenArguments {
  final String title;
  final String rating;
  final String description;
  final String imagePath;
  final String ratingCount;
  final String prices;

  DetailsScreenArguments({
    this.title = "",
    this.rating = "",
    this.description = "",
    this.imagePath = "",
    this.ratingCount = "",
    required this.prices,
  });
}

class HomeController extends ChangeNotifier {
  void navigateToDetailsPage(BuildContext context, DocumentSnapshot doc) {
    Navigator.pushNamed(
      context,
      RouteGenerator.detailsPage,
      arguments: DetailsScreenArguments(
          title: getTitle(doc),
          rating: getRating(doc),
          description: getDescription(doc),
          imagePath: getImagePath(doc),
          ratingCount: getRatingCount(doc),
          prices: getPrice(doc)),
    );
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
