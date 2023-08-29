import 'package:food_delivery_app/utils/card/card_type.dart';

class PaymentCard {
  String? id;
  CardType type;
  String number;
  String name;
  int month;
  int year;
  int cvv;

  PaymentCard(
      {this.id,
      required this.type,
      required this.number,
      required this.name,
      required this.month,
      required this.year,
      required this.cvv});

  Map<String, dynamic> toJson() {
    return {
      "id" : id,
      "type": type,
      "number": number,
      "name": name,
      "month": month,
      "year": year,
      "cvv": cvv
    };
  }

  @override
  String toString() {
    return '[Type: $type, Number: $number, Name: $name, Month: $month, Year: $year, CVV: $cvv]';
  }
}
