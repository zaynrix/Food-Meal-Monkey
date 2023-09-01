import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:food_delivery_app/core/model/payment_card.dart';
import 'package:food_delivery_app/routing/navigations.dart';
import 'package:food_delivery_app/utils/card/card_type.dart';
import 'package:food_delivery_app/utils/card/card_utilis.dart';
import 'package:food_delivery_app/utils/helper.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';

class PaymentController extends ChangeNotifier {
  PaymentController({required this.sharedPreferences});

  final SharedPreferences sharedPreferences;

  CardType cardType = CardType.Invalid;

  void getCardTypeFrmNum({required String cardNumber}) {
    if (cardNumber.length <= 6) {
      String cardNum = CardUtils.getCleanedNumber(cardNumber);
      CardType type = CardUtils.getCardTypeFrmNumber(cardNum);
      debugPrint("This is card type =>>> $type \n");
      if (type != cardType) {
        cardType = type;
        notifyListeners();
      }
    }
  }

  List<PaymentCard> paymentCards = [];


  String getUserId() {
    return sharedPreferences.getString("userId") ?? "null id";
  }

  Future<void> addNewCard({required PaymentCard card}) async {
    print("add item to cart");
    try {
      final String randomId = Uuid().v4();
      card.id = randomId;
      final jsonProduct = card.toJson();
      final productSnapshot = await _getPaymentCardsQuerySnapshot(card);
      if (productSnapshot.docs.isEmpty) {
        await _addCardToFirestore(card.id ?? "null id", jsonProduct);

        print("Item added to cart");
        notifyListeners();
        fetchPaymentCards();
        ServiceNavigation.serviceNavi.back();
        Helpers.showSnackBar(
            message: "Card Added successfully", isSuccess: true);
      } else {
        Helpers.showSnackBar(
            message: "This Card is already added", isSuccess: false);
      }
    } catch (error) {
      debugPrint('Error adding item to Firestore: $error');
    }
  }

  Future<void> fetchPaymentCards() async {
    try {
      final paymentsCardSnapshot = await _getPaymentCardsSnapshot();
      if (paymentsCardSnapshot.docs.isNotEmpty) {
        paymentCards = _mapPaymentCardsData(paymentsCardSnapshot.docs);
        notifyListeners();
      } else {
        print("Cart items not found");
      }
    } catch (error) {
      print('Error fetching cart items: $error');
    }
  }

  Future<void> deleteCard(PaymentCard card) async {
    try {
      debugPrint("This is inside delete function");
      final userId = getUserId();
      debugPrint(
          "This is querySnapshot inside delete function in controller ");
      // if (querySnapshot.size == 1) {
      debugPrint("This is docIf ${card.id}");

      await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .collection('paymentMethods')
          .doc(card.id)
          .delete();
      paymentCards.remove(card);
      notifyListeners();
      Helpers.showSnackBar(message: "Product deleted successfully", isSuccess: false);

    } catch (e) {
      debugPrint("Error in delete item >> $e");
    }
  }


  List<PaymentCard> _mapPaymentCardsData(List<QueryDocumentSnapshot> docs) {
    return docs.map((itemData) {
      final data = itemData.data() as Map;
      return PaymentCard(
          id: data["id"],
          type: data["type"],
          number: data["number"],
          name: data["name"],
          date: data["date"],
          cvv: data["cvv"]);
    }).toList();
  }

  Future<QuerySnapshot> _getPaymentCardsSnapshot() {
    final userId = getUserId();

    return FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .collection("paymentMethods")
        .get();
  }

  Future<void> _addCardToFirestore(
      String cardId, Map<String, dynamic> jsonCard) {
    final userId = getUserId();

    return FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .collection("paymentMethods")
        .doc(cardId)
        .set(jsonCard);
  }

  Future<QuerySnapshot> _getPaymentCardsQuerySnapshot(PaymentCard card) {
    final userId = getUserId();

    return FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .collection("paymentMethods")
        .where('id', isEqualTo: card.id)
        .get();
  }
}
