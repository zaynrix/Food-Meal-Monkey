import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:food_delivery_app/core/model/models.dart';

class CartController extends ChangeNotifier {
  List<ProductModel> cartProducts = [];

  Future<void> fetchFoodItemsFromFirestore() async {
    debugPrint(("This is inside fetch in provider"));
    try {
      final snapshot =
          await FirebaseFirestore.instance.collection('cart').get();
      debugPrint("This is snapshot  >>>> ${snapshot.docs}");

      cartProducts = snapshot.docs.map((doc) {
        Map<String, dynamic> data = doc.data();
        debugPrint("This is data >>>> $data");
        return ProductModel.fromJson(data);
      }).toList();
      debugPrint("This is the cartProducts :>>>> \n $cartProducts");
      notifyListeners();
    } catch (error) {
      print('Error fetching food items: $error');
    }
  }

  Future<void> addItemToCard({required ProductModel product}) async {
    try{
      await FirebaseFirestore.instance.collection('cart').add(product.toJson());
    } catch (error) {
      print('Error adding item to Firestore: $error');
    }
  }

  Future<void> updateProductInFirestore(ProductModel product) async {
    try {
      final querySnapshot = await FirebaseFirestore.instance
          .collection('cart')
          .where('name', isEqualTo: product.name)
          .where('resName', isEqualTo: product.resName)
          .get();
      if (querySnapshot.size == 1) {
        final docId = querySnapshot.docs.first.id;
        await FirebaseFirestore.instance
            .collection('cart')
            .doc(docId)
            .update({'cartQuantity': product.cartQuantity});
      } else {
        print('Product not found or not unique');
      }
    } catch (error) {
      print('Error updating product in Firestore: $error');
    }
  }

  incrementProduct(ProductModel item) {
    final index = cartProducts.indexOf(item);
    if (index != -1) {
      final newCartQuantity = (item.cartQuantity) + 1;
      cartProducts[index].cartQuantity = newCartQuantity;
      notifyListeners();
    }
  }

  decrementProduct(ProductModel item) {
    final index = cartProducts.indexOf(item);
    if (index != -1 && item.cartQuantity > 0) {
      final newCartQuantity = (item.cartQuantity) - 1;
      cartProducts[index].cartQuantity = newCartQuantity;
      notifyListeners();
    }
  }

  void addToCart(int index) {
    cartProducts[index].inCart = true;
    cartProducts[index].cartQuantity++;
    notifyListeners();
  }

  void removeFromCart(int index) {
    cartProducts[index].inCart = false;
    cartProducts[index].cartQuantity = 0;
    notifyListeners();
  }
}
