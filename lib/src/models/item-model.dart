part of models;

class ItemModel {
  ItemModel({required this.imagePath,
    required this.name,
    required this.label,
    required this.rating,
     this.ratingCount});

  final String imagePath;
  final String name;
  final String label;
  final double rating;
  final int? ratingCount;
  static List<ItemModel> popular = [
    ItemModel(imagePath: "assets/imags/a.png",
        name: "Minute by tuk tuk",
        label: "Western Food",
        rating: 4.9,
        ratingCount: 124),
    ItemModel(imagePath: "assets/imags/s.png",
        name: "Minute by tuk tuk",
        label: "Western Food",
        rating: 4.9,
        ratingCount: 124),
    ItemModel(imagePath: "assets/imags/d.png",
        name: "Minute by tuk tuk",
        label: "Western Food",
        rating: 4.9,
        ratingCount: 124),
  ];

  static List<ItemModel> mostPopular = [
    ItemModel(imagePath: "assets/imags/a.png",
        name: "Minute by tuk tuk",
        label: "Western Food",
        rating: 4.9,
       ),
    ItemModel(imagePath: "assets/imags/s.png",
        name: "Minute by tuk tuk",
        label: "Western Food",
        rating: 4.9,
        ),
    ItemModel(imagePath: "assets/imags/d.png",
        name: "Minute by tuk tuk",
        label: "Western Food",
        rating: 4.9,
        ),
  ];

  static List<ItemModel> recentItem = [
    ItemModel(imagePath: "assets/imags/a.png",
        name: "Minute by tuk tuk",
        label: "Western Food",
        rating: 4.9,
        ratingCount: 124),
    ItemModel(imagePath: "assets/imags/s.png",
        name: "Minute by tuk tuk",
        label: "Western Food",
        rating: 4.9,
        ratingCount: 124),
    ItemModel(imagePath: "assets/imags/d.png",
        name: "Minute by tuk tuk",
        label: "Western Food",
        rating: 4.9,
        ratingCount: 124),
  ];
}