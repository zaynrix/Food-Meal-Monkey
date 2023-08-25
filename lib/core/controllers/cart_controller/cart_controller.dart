import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:food_delivery_app/core/model/models.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CartController extends ChangeNotifier {
  CartController({required this.sharedPreferences});

  final SharedPreferences sharedPreferences;
  List<ProductModel> cartItems = [];

  // Fetch cart items from Firestore
  Future<void> fetchCartItems() async {
    try {
      final email = sharedPreferences.getString("email") ?? "null email";
      final userSnapshot = await _getUserSnapshotByEmail(email);

      if (userSnapshot.docs.isNotEmpty) {
        final userId = userSnapshot.docs.first.id;
        final cartItemsSnapshot = await _getCartItemsSnapshot(userId);

        if (cartItemsSnapshot.docs.isNotEmpty) {
          cartItems = _mapCartItemsData(cartItemsSnapshot.docs);
          notifyListeners();
        } else {
          print("Cart items not found");
        }
      } else {
        print("User document not found");
      }
    } catch (error) {
      print('Error fetching cart items: $error');
    }
  }

  // Add an item to the cart
  Future<void> addItemToCart({required ProductModel product}) async {
    try {
      product.cartQuantity++;
      product.inCart = true;
      final jsonProduct = product.toJson();
      final email = sharedPreferences.getString("email") ?? "null email";
      final userSnapshot = await _getUserSnapshotByEmail(email);

      if (userSnapshot.docs.isNotEmpty) {
        final userId = userSnapshot.docs.first.id;
        await _addProductToFirestore(userId, jsonProduct);
        print("Item added to cart");

        notifyListeners();
      }
    } catch (error) {
      print('Error adding item to Firestore: $error');
    }
  }

  // Update cart item's quantity
  Future<void> updateCartItemQuantity(ProductModel product) async {
    try {
      final email = sharedPreferences.getString("email") ?? "null email";
      final userSnapshot = await _getUserSnapshotByEmail(email);

      if (userSnapshot.docs.isNotEmpty) {
        final userId = userSnapshot.docs.first.id;
        final querySnapshot = await _getCartItemQuerySnapshot(userId, product);

        if (querySnapshot.size == 1) {
          final docId = querySnapshot.docs.first.id;
          await _updateCartItemQuantity(userId, docId, product.cartQuantity as double);

          notifyListeners();
        } else {
          print('Product not found or not unique');
        }
      }
    } catch (error) {
      print('Error updating product in Firestore: $error');
    }
  }

  incrementProduct(ProductModel item) {
    final index = cartItems.indexOf(item);
    if (index != -1) {
      final newCartQuantity = (item.cartQuantity) + 1;
      cartItems[index].cartQuantity = newCartQuantity;
      notifyListeners();
    }
  }

  Future<void> deleteProduct(ProductModel product) async {
    try {
      debugPrint("This is inside delete function");
      final email = sharedPreferences.getString("email") ?? "null email";

      final userSnapshot = await FirebaseFirestore.instance
          .collection('users')
          .where('email', isEqualTo: email)
          .get();

      if (userSnapshot.docs.isNotEmpty) {
        final userId = userSnapshot.docs.first.id;
        debugPrint("This is id of user ===>> $userId \n");

        final querySnapshot = await FirebaseFirestore.instance
            .collection('users')
            .doc(userId)
            .collection("cartItems")
            .where('name', isEqualTo: product.name)
            .where('resName', isEqualTo: product.resName)
            .get();
        debugPrint("This is querySnapshot inside delete function in controller $querySnapshot");
        if (querySnapshot.size == 1) {
          final docId = querySnapshot.docs.first.id;
          debugPrint("This is docIf $docId");
          await FirebaseFirestore.instance.collection('users')
              .doc(userId)
              .collection('cartItems')
              .doc(docId)
              .delete();
          cartItems.remove(product);
          notifyListeners();
        } else {
          print('Product not found or not unique');
        }
      }}catch (e){
    debugPrint("Error in delete item >> $e");
    }
  }

  decrementProduct(ProductModel item) {
    debugPrint("This decrementProduct function");
    final index = cartItems.indexOf(item);
    if (item.cartQuantity != 0) {
      debugPrint("This Quantity before min ${item.cartQuantity}");
      debugPrint("This inside if in decrement");
      final newCartQuantity = (item.cartQuantity) - 1;
      cartItems[index].cartQuantity = newCartQuantity;
      debugPrint("This Quantity after min ${item.cartQuantity}");
      if (item.cartQuantity == 0) {
        debugPrint("This is before call deleteProduct function");
        deleteProduct(item);
      }
      notifyListeners();
    }
  }

  // Private helper methods

  Future<QuerySnapshot> _getUserSnapshotByEmail(String email) {
    return FirebaseFirestore.instance
        .collection('users')
        .where('email', isEqualTo: email)
        .get();
  }

  Future<QuerySnapshot> _getCartItemsSnapshot(String userId) {
    return FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .collection("cartItems")
        .get();
  }

  List<ProductModel> _mapCartItemsData(List<QueryDocumentSnapshot> docs) {
    return docs.map((itemData) {
      final data = itemData.data() as Map;
      return ProductModel(
        name: data['name'],
        imagePath: data['imagePath'],
        price: data['price'],
        rating: data['rating'],
        ratingCount: data["ratingCount"],
        inCart: data["inCart"],
        cartQuantity: data["cartQuantity"],
        description: data["description"],
        resName: data["resName"],
      );
    }).toList();
  }

  Future<void> _addProductToFirestore(String userId, Map<String, dynamic> jsonProduct) {
    return FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .collection("cartItems")
        .add(jsonProduct);
  }

  Future<QuerySnapshot> _getCartItemQuerySnapshot(String userId, ProductModel product) {
    return FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .collection("cartItems")
        .where('name', isEqualTo: product.name)
        .where('resName', isEqualTo: product.resName)
        .get();
  }

  Future<void> _updateCartItemQuantity(String userId, String docId, double quantity) {
    return FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .collection("cartItems")
        .doc(docId)
        .update({'cartQuantity': quantity});
  }
}



// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:food_delivery_app/core/model/models.dart';
// import 'package:shared_preferences/shared_preferences.dart';
//
// class CartController extends ChangeNotifier {
//   CartController({required this.sharedPreferences});
//
//   final SharedPreferences sharedPreferences;
//   List<ProductModel> cartItems = [];
//
//   Future<void> fetchCartItems() async {
//     try {
//       final email = sharedPreferences.getString("email") ?? "null email";
//
//       final userSnapshot = await FirebaseFirestore.instance
//           .collection('users')
//           .where('email', isEqualTo: email)
//           .get();
//
//       if (userSnapshot.docs.isNotEmpty) {
//         final userId = userSnapshot.docs.first.id;
//         debugPrint("This is id of user ===>> $userId \n");
//
//         final cartItemsSnapshot = await FirebaseFirestore.instance
//             .collection('users')
//             .doc(userId)
//             .collection("cartItems")
//             .get();
//
//         debugPrint("This is snapshot ==>>>> ${cartItemsSnapshot.docs.length}");
//
//         if (cartItemsSnapshot.docs.isNotEmpty) {
//           final cartItemsData = cartItemsSnapshot.docs;
//           debugPrint(
//               "This is cartItemsData ==>>>> ${cartItemsData.first.data()}");
//
//           cartItems = cartItemsData.map((itemData) {
//             final data = itemData.data();
//             return ProductModel(
//               name: data['name'],
//               imagePath: data['imagePath'],
//               price: data['price'],
//               rating: data['rating'],
//               ratingCount: data["ratingCount"],
//               inCart: data["inCart"],
//               cartQuantity: data["cartQuantity"],
//               description: data["description"],
//               resName: data["resName"],
//             );
//           }).toList();
//
//           notifyListeners();
//         } else {
//           debugPrint("Cart items not found");
//         }
//       } else {
//         debugPrint("User document not found");
//       }
//     } catch (error) {
//       print('Error fetching cart items: $error');
//     }
//   }
//
//   Future<void> addItemToCard({required ProductModel product}) async {
//     try {
//       product.cartQuantity++;
//       product.inCart = true;
//       final jsonProduct = product.toJson();
//       debugPrint("This is jsonProduct in controller >>>>> $jsonProduct");
//       final email = sharedPreferences.getString("email") ?? "null email";
//
//       final userSnapshot = await FirebaseFirestore.instance
//           .collection('users')
//           .where('email', isEqualTo: email)
//           .get();
//
//       if (userSnapshot.docs.isNotEmpty) {
//         final userId = userSnapshot.docs.first.id;
//         debugPrint("This is id of user ===>> $userId \n");
//
//         await FirebaseFirestore.instance
//             .collection('users')
//             .doc(userId)
//             .collection("cartItems")
//             .add(jsonProduct);
//         debugPrint("This is inside add function in controller");
//       }
//     } catch (error) {
//       print('Error adding item to Firestore: $error');
//     }
//   }
//
//   // Future<void> updateProductInFirestore(ProductModel product) async {
//   //   try {
//   //     final email = sharedPreferences.getString("email") ?? "null email";
//   //
//   //     final userSnapshot = await FirebaseFirestore.instance
//   //         .collection('users')
//   //         .where('email', isEqualTo: email)
//   //         .get();
//   //
//   //     if (userSnapshot.docs.isNotEmpty) {
//   //       final userId = userSnapshot.docs.first.id;
//   //       debugPrint("This is id of user ===>> $userId \n");
//   //
//   //       final querySnapshot = await FirebaseFirestore.instance
//   //           .collection('users')
//   //           .doc(userId)
//   //           .collection("cartItems").where('name', isEqualTo: product.name)
//   //           .where('resName', isEqualTo: product.resName)
//   //           .get();
//   //       debugPrint("This is inside add function in controller");
//   //     if (querySnapshot.size == 1) {
//   //       final docId = querySnapshot.docs.first.id;
//   //       await FirebaseFirestore.instance
//   //           .collection('users')
//   //           .doc(docId).collection("cartItems")
//   //           .update({'cartQuantity': product.cartQuantity});
//   //     } else {
//   //       print('Product not found or not unique');
//   //     }
//   //   }} catch (error) {
//   //     print('Error updating product in Firestore: $error');
//   //   }
//   // }
//   Future<void> updateProductInFirestore(ProductModel product) async {
//     try {
//       final email = sharedPreferences.getString("email") ?? "null email";
//
//       final userSnapshot = await FirebaseFirestore.instance
//           .collection('users')
//           .where('email', isEqualTo: email)
//           .get();
//
//       if (userSnapshot.docs.isNotEmpty) {
//         final userId = userSnapshot.docs.first.id;
//         debugPrint("This is id of user ===>> $userId \n");
//
//         final querySnapshot = await FirebaseFirestore.instance
//             .collection('users')
//             .doc(userId)
//             .collection("cartItems")
//             .where('name', isEqualTo: product.name)
//             .where('resName', isEqualTo: product.resName)
//             .get();
//
//         if (querySnapshot.size == 1) {
//           final docId = querySnapshot.docs.first.id;
//           await FirebaseFirestore.instance
//               .collection('users')
//               .doc(userId)
//               .collection("cartItems")
//               .doc(docId)
//               .update({'cartQuantity': product.cartQuantity});
//
//           // Notify listeners to reflect the changes in the UI
//           notifyListeners();
//         } else {
//           print('Product not found or not unique');
//         }
//       }
//     } catch (error) {
//       print('Error updating product in Firestore: $error');
//     }
//   }
//
//   Future<void> deleteProduct(ProductModel product) async {
//     try {
//       final email = sharedPreferences.getString("email") ?? "null email";
//
//       final userSnapshot = await FirebaseFirestore.instance
//           .collection('users')
//           .where('email', isEqualTo: email)
//           .get();
//
//       if (userSnapshot.docs.isNotEmpty) {
//         final userId = userSnapshot.docs.first.id;
//         debugPrint("This is id of user ===>> $userId \n");
//
//         final querySnapshot = await FirebaseFirestore.instance
//             .collection('users')
//             .doc(userId)
//             .collection("cartItems")
//             .where('name', isEqualTo: product.name)
//             .where('resName', isEqualTo: product.resName)
//             .get();
//         debugPrint("This is inside add function in controller");
//         if (querySnapshot.size == 1) {
//           final docId = querySnapshot.docs.first.id;
//           await FirebaseFirestore.instance
//               .collection('cartItems')
//               .doc(docId)
//               .delete();
//         } else {
//           print('Product not found or not unique');
//         }
//       }
//
//       final querySnapshot = await FirebaseFirestore.instance
//           .collection('cart')
//           .where('name', isEqualTo: product.name)
//           .where('resName', isEqualTo: product.resName)
//           .get();
//       if (querySnapshot.size == 1) {
//         final docId = querySnapshot.docs.first.id;
//         await FirebaseFirestore.instance.collection('cart').doc(docId).delete();
//
//         final index = cartItems.indexOf(product);
//         cartItems.removeAt(index);
//         notifyListeners();
//       } else {
//         print('Product not found or not unique');
//       }
//     } catch (error) {
//       print('Error updating product in Firestore: $error');
//     }
//   }
//
//   incrementProduct(ProductModel item) {
//     final index = cartItems.indexOf(item);
//     if (index != -1) {
//       final newCartQuantity = (item.cartQuantity) + 1;
//       cartItems[index].cartQuantity = newCartQuantity;
//       notifyListeners();
//     }
//   }
//
//   decrementProduct(ProductModel item) {
//     final index = cartItems.indexOf(item);
//     if (index != -1 && item.cartQuantity > 0) {
//       final newCartQuantity = (item.cartQuantity) - 1;
//       cartItems[index].cartQuantity = newCartQuantity;
//       notifyListeners();
//     }
//     if (item.cartQuantity == 0) {
//       deleteProduct(item);
//     }
//   }
// }
