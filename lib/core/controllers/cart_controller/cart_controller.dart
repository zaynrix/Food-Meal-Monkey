import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:food_delivery_app/core/controllers/auth_controller/auth_controller.dart';
import 'package:food_delivery_app/core/controllers/payment_controller/payment_controller.dart';
import 'package:food_delivery_app/core/model/models.dart';
import 'package:food_delivery_app/core/model/order_model.dart';
import 'package:food_delivery_app/core/model/payment_card.dart';
import 'package:food_delivery_app/routing/navigations.dart';
import 'package:food_delivery_app/service_locator.dart';
import 'package:food_delivery_app/utils/enums.dart';
import 'package:food_delivery_app/utils/helper.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';

class CartController extends ChangeNotifier {
  CartController({required this.sharedPreferences});

  final SharedPreferences sharedPreferences;
  List<ProductModel> cartItems = [];
  bool isLoading = false;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;


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

  startLoading() {
    isLoading = true;
    notifyListeners();
  }

  stopLoading() {
    isLoading = false;
    notifyListeners();
  }

  String getUserId() {
    debugPrint("This is inside stop loading");
    return sl<AuthController>().auth.currentUser!.uid;
  }

  Future<void> fetchCartItems() async {
    try {
      isLoading = true;
      final cartItemsSnapshot = await _getCartItemsSnapshot();
      if (cartItemsSnapshot.docs.isNotEmpty) {
        cartItems = _mapCartItemsData(cartItemsSnapshot.docs);
        isLoading = false;
        notifyListeners();
      } else {
        isLoading = false;
        notifyListeners();
        print("Cart items not found");
      }
    } catch (error) {
      isLoading = false;
      notifyListeners();
      print('Error fetching cart items: $error');
    }
  }

  // Add an item to the cart
  Future<void> addItemToCart({required ProductModel product}) async {
    print("add item to cart");
    try {
      startDialogLoading();
      product.inCart = true;
      product.cartQuantity++;
      final jsonProduct = product.toJson();

      final productSnapshot = await _getCartItemQuerySnapshot(product);
      if (productSnapshot.docs.isEmpty) {
        await _addProductToFirestore(product.id, jsonProduct);
        product.cartQuantity = 0;
        print("Item added to cart");
        stopDialogLoading();
        notifyListeners();
        Helpers.showSnackBar(
            message: "Product Added successfully", isSuccess: true);
      } else {
        stopDialogLoading();
        Helpers.showSnackBar(
            message: "This Product is already added", isSuccess: false);
      }
    } catch (error) {
      stopDialogLoading();
      debugPrint('Error adding item to Firestore: $error');
    }
  }

  // Update cart item's quantity
  Future<void> updateCartItemQuantity(ProductModel product) async {
    try {
      startLoading();
      final querySnapshot = await _getCartItemQuerySnapshot(product);
      if (querySnapshot.size == 1) {
        await _updateCartItemQuantity(
            product.id, product.cartQuantity as double);
        stopLoading();
        notifyListeners();
      } else {
        stopLoading();
        print('Product not found or not unique');
      }
    } catch (error) {
      stopLoading();
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

  incrementUiItem(ProductModel product) {
    product.cartQuantity++;
    notifyListeners();
  }

  decrementUiItem(ProductModel product) {
    if (product.cartQuantity + 1 > 1) {
      product.cartQuantity--;
      notifyListeners();
    }
  }

  Future<void> deleteProduct(ProductModel product) async {
    try {
      debugPrint("This is inside delete function");
      debugPrint("This is querySnapshot inside delete function in controller ");
      debugPrint("This is docIf ${product.id}");
      await _deleteProduct(productId: product.id);
      cartItems.remove(product);
      notifyListeners();
      Helpers.showSnackBar(
          message: "Product deleted successfully", isSuccess: false);
    } catch (e) {
      debugPrint("Error in delete item >> $e");
    }
  }

  Future<void> _deleteProduct({required String productId}) async {
    final userId = getUserId();
    await _firestore
        .collection('users')
        .doc(userId)
        .collection('cartItems')
        .doc(productId)
        .delete();
  }

  Future<void> deleteCollection(String collectionPath) async {
    debugPrint("This is inside deleteCollection");
    final userId = getUserId();
    final CollectionReference collectionReference = FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .collection(collectionPath);

    final QuerySnapshot querySnapshot = await collectionReference.get();

    for (QueryDocumentSnapshot documentSnapshot in querySnapshot.docs) {
      await documentSnapshot.reference.delete();
    }
  }

  String calculateSubtotal() {
    double subtotal = 0.0;
    for (var product in cartItems) {
      num price = product.price;
      num cartQuantity = product.cartQuantity;
      subtotal += price * cartQuantity;
    }
    return subtotal.toStringAsFixed(2);
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

    return _firestore
        .collection('users')
        .doc(userId)
        .collection("cartItems")
        .get();
  }

  List<ProductModel> _mapCartItemsData(List<QueryDocumentSnapshot> docs) {
    return docs.map((itemData) {
      final data = itemData.data() as Map<String, dynamic>;
      return ProductModel.fromJson(data);
    }).toList();
  }

  Future<void> _addProductToFirestore(
      String productId, Map<String, dynamic> jsonProduct) {
    final userId = getUserId();

    return _firestore
        .collection('users')
        .doc(userId)
        .collection("cartItems")
        .doc(productId)
        .set(jsonProduct);
  }

  Future<void> _addOrderToFirestore(
      String orderId, Map<String, dynamic> jsonOrder) {
    final userId = getUserId();
    return _firestore
        .collection('users')
        .doc(userId)
        .collection("orders")
        .doc(orderId)
        .set(jsonOrder);
  }

  Future<QuerySnapshot> _getCartItemQuerySnapshot(ProductModel product) {
    final userId = getUserId();

    return _firestore
        .collection('users')
        .doc(userId)
        .collection("cartItems")
        .where('id', isEqualTo: product.id)
        .get();
  }

  Future<void> _updateCartItemQuantity(String docId, double quantity) {
    final userId = getUserId();
    return _firestore
        .collection('users')
        .doc(userId)
        .collection("cartItems")
        .doc(docId)
        .update({'cartQuantity': quantity});
  }



  Future<void> makeOrder() async {
    PaymentCard? currantCard = Provider.of<PaymentController>(
        ServiceNavigation.scaffoldKey.currentState!.context,
        listen: false)
        .currantCard;
    try {
      startDialogLoading();
      if (currantCard ==
          null) {
        Helpers.showSnackBar(message: "Pleas Select Card", isSuccess: false);
        stopDialogLoading();
      } else {
        final String randomId = Uuid().v4();
        final OrderModel order = OrderModel(
            id: randomId,
            createdAt: DateTime.now().toIso8601String(),
            status: "In Processing",
            location: "Gaza",
            products: cartItems,
            price: calculateSubtotal());
        final orderJson = order.toJson();
        await _addOrderToFirestore(order.id, orderJson);
        await deleteCollection("cartItems");
        cartItems = [];
        stopDialogLoading();
        ServiceNavigation.serviceNavi.back();
        Helpers.showSnackBar(
            message: "Order Added successfully", isSuccess: true);
      }
    } catch (e) {
      stopDialogLoading();
      debugPrint("Error in Make Order : >>> $e");
    }
  }

  @override
  dispose() {
    super.dispose();
    cartItems = [];
    notifyListeners();
  }

  disposeCartController() {
    cartItems = [];
    notifyListeners();
  }
}
