
class PaymentCard {
  String? id;
  String type;
  String number;
  String name;
  String date;
  String cvv;

  PaymentCard(
      {this.id,
      required this.type,
      required this.number,
      required this.name,
      required this.date,
      required this.cvv});

  Map<String, dynamic> toJson() {
    return {
      "id" : id,
      "type": type,
      "number": number,
      "name": name,
      "date": date,
      "cvv": cvv
    };
  }

  @override
  String toString() {
    return '[Type: $type, Number: $number, Name: $name, date: $date, CVV: $cvv]';
  }
}
