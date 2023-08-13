import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:food_delivery_app/routing/router.dart';

class DetailsScreenArguments {
  final String title;
  final String rating;
  final String description;
  final String imagePath;
  final String ratingCount;

  DetailsScreenArguments({
    required this.title,
    required this.rating,
    required this.description,
    required this.imagePath,
    required this.ratingCount,
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
      ),
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
    return doc['rating'];
  }

  String getDescription(DocumentSnapshot doc) {
    return doc['description'];
  }

  String getImagePath(DocumentSnapshot doc) {
    return doc['imagePath'];
  }

  String getRatingCount(DocumentSnapshot doc) {
    return doc['ratingCount'];
  }
}
