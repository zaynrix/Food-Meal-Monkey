import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:food_delivery_app/core/controllers/auth_controller/auth_controller.dart';
import 'package:food_delivery_app/core/model/order_model.dart';
import 'package:food_delivery_app/routing/navigations.dart';
import 'package:food_delivery_app/service_locator.dart';
import 'package:food_delivery_app/utils/enums.dart';
import 'package:food_delivery_app/utils/helper.dart';

class OrderController extends ChangeNotifier {
  String getUserId() {
    debugPrint("This is inside stop loading");
    return sl<AuthController>().auth.currentUser!.uid;
  }

  bool isLoading = false;

  startDialogLoading() {
    isLoading = true;
    notifyListeners();
    debugPrint("This is inside start loading");
    Helpers.showLoadingDialog(
        message: "Loading...", status: LoadingStatusOption.loading);
  }

  stopDialogLoading() {
    isLoading = false;
    notifyListeners();
    ServiceNavigation.serviceNavi.back();
  }

  Future<QuerySnapshot> _getOrdersSnapshot() {
    final userId = getUserId();

    return FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .collection("orders")
        .get();
  }

  List<OrderModel> _mapOrdersData(List<QueryDocumentSnapshot> docs) {
    return docs.map((itemData) {
      final data = itemData.data() as Map<String, dynamic>;
      return OrderModel.fromJson(data);
    }).toList();
  }

  startLoading() {
    isLoading = true;
    notifyListeners();
  }

  stopLoading() {
    isLoading = false;
    notifyListeners();
  }

  List<OrderModel> orders = [];

  Future<void> fetchOrders() async {
    try {
      startLoading();
      final ordersSnapshot = await _getOrdersSnapshot();
      orders = _mapOrdersData(ordersSnapshot.docs);
      isLoading = false;
      notifyListeners();
    } catch (e) {
      stopLoading();
      debugPrint("Error in fetch orders : >>> $e");
    }
  }


}
