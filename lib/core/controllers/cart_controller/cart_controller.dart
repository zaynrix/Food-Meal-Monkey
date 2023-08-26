import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:food_delivery_app/core/model/models.dart';
import 'package:food_delivery_app/utils/helper.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CartController extends ChangeNotifier {
  CartController({required this.sharedPreferences});

  final SharedPreferences sharedPreferences;
  List<ProductModel> cartItems = [];

  String getUserId() {
    return sharedPreferences.getString("userId") ?? "null id";
  }

  Future<void> fetchCartItems() async {
    try {
      final cartItemsSnapshot = await _getCartItemsSnapshot();
      if (cartItemsSnapshot.docs.isNotEmpty) {
        cartItems = _mapCartItemsData(cartItemsSnapshot.docs);
        notifyListeners();
      } else {
        print("Cart items not found");
      }
    } catch (error) {
      print('Error fetching cart items: $error');
    }
  }

  // Add an item to the cart
  Future<void> addItemToCart({required ProductModel product}) async {
    print("add item to cart");
    try {
      product.cartQuantity++;
      product.inCart = true;
      final jsonProduct = product.toJson();
      final productSnapshot = await _getCartItemQuerySnapshot(product);
      if (productSnapshot.docs.isEmpty) {
        await _addProductToFirestore(product.id, jsonProduct);

        print("Item added to cart");
        notifyListeners();
        Helpers.showSnackBar(message: "Product Added successfully", isSuccess: true);
      }
      else{
        Helpers.showSnackBar(message: "This Product is already added", isSuccess: false);
      }
    } catch (error) {
      debugPrint('Error adding item to Firestore: $error');
    }
  }

  // Update cart item's quantity
  Future<void> updateCartItemQuantity(ProductModel product) async {
    try {
      final querySnapshot = await _getCartItemQuerySnapshot(product);
      if (querySnapshot.size == 1) {
        await _updateCartItemQuantity(product.id, product.cartQuantity as double);
        notifyListeners();
      } else {
        print('Product not found or not unique');

    
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
      final userId = getUserId();
        debugPrint(
            "This is querySnapshot inside delete function in controller ");
        // if (querySnapshot.size == 1) {
          debugPrint("This is docIf ${product.id}");

          await FirebaseFirestore.instance
              .collection('users')
              .doc(userId)
              .collection('cartItems')
              .doc(product.id)
              .delete();
          cartItems.remove(product);
          notifyListeners();
      Helpers.showSnackBar(message: "Product deleted successfully", isSuccess: false);

    } catch (e) {
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
        notifyListeners();
      }
      print("out if ");
    }
  }


  Future<QuerySnapshot> _getCartItemsSnapshot() {
    final userId = getUserId();

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
          id: data["id"]);
    }).toList();
  }

  Future<void> _addProductToFirestore(
      String productId, Map<String, dynamic> jsonProduct) {
    final userId = getUserId();

    return FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .collection("cartItems")
        .doc(productId)
        .set(jsonProduct);
  }

  Future<QuerySnapshot> _getCartItemQuerySnapshot(ProductModel product) {
    final userId = getUserId();


    return FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .collection("cartItems")
        .where('id', isEqualTo: product.id)
        .get();
  }

  Future<void> _updateCartItemQuantity(String docId, double quantity) {
    final userId = getUserId();
    return FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .collection("cartItems")
        .doc(docId)
        .update({'cartQuantity': quantity});
  }


  @override
  dispose(){
    super.dispose();
    cartItems = [];
    notifyListeners();
  }

  disposeCartController(){
    cartItems = [];
    notifyListeners();
  }
}




