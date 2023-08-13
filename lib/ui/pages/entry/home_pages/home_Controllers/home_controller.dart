import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:food_delivery_app/routing/navigations.dart';
import 'package:food_delivery_app/routing/router.dart';

class HomeController extends ChangeNotifier {
  void navigateToDetailsPage(BuildContext context) {
    ServiceNavigation.serviceNavi.pushNamedWidget(
      RouteGenerator.detailsPage,
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
