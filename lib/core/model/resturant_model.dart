class FoodItem {
  final String id;
  final String name;
  final String description;
  final String imagePath;
  final double rating;
  final int ratingCount;
  final int price;
  final bool inCart;
  final int cartQuantity;

  FoodItem({
    required this.id,
    required this.name,
    required this.description,
    required this.imagePath,
    required this.rating,
    required this.ratingCount,
    required this.price,
    required this.inCart,
    required this.cartQuantity,
  });

  factory FoodItem.fromFirestore(Map<String, dynamic> json) {
    return FoodItem(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      imagePath: json['imagePath'],
      rating: json['rating'].toDouble(),
      ratingCount: json['ratingCount'],
      price: json['price'],
      inCart: json['inCart'],
      cartQuantity: json['cartQuantity'],
    );
  }
}
