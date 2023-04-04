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


  static List<ItemModel> popularRestaurents = [
    ItemModel(imagePath: "assets/images/a.png",
        name: "Minute by tuk tuk",
        label: "Western Food",
        rating: 4.9,
        ratingCount: 124),
    ItemModel(imagePath: "assets/images/s.png",
        name: "Café de Noir",
        label: "Western Food",
        rating: 4.9,
        ratingCount: 124),
    ItemModel(imagePath: "assets/images/d.png",
        name: "Bakes by Tella",
        label: "Western Food",
        rating: 4.9,
        ratingCount: 124),
  ];

  //----------------------------------------------------------------------------

  static List<ItemModel> mostPopular = [
    ItemModel(imagePath: ImageAssets.bambaaMostPopular,
        name: "Café De Bambaa",
        label: "Western Food",
        rating: 4.9,
       ),
    ItemModel(imagePath: ImageAssets.burgarMostPopular,
        name: "Minute by tuk tuk",
        label: "Western Food",
        rating: 4.9,
        ),
  ];

//------------------------------------------------------------------------------

  static List<ItemModel> recentItem = [
    ItemModel(imagePath: ImageAssets.mulberryResentItem,
        name: "Mulberry Pizza by Josh",
        label: "Western Food",
        rating: 4.9,
        ratingCount: 124),
    ItemModel(imagePath: ImageAssets.baritaResentItem,
        name: "Barita",
        label: "Coffee",
        rating: 4.9,
        ratingCount: 124),
    ItemModel(imagePath: ImageAssets.pizzaRushResentItem,
        name: "Pizza Rush Hour",
        label: "Italian Food",
        rating: 4.9,
        ratingCount: 124),
  ];


//------------------------------------------------------------------------------

  static List<ItemModel> desserts = [
    ItemModel(imagePath: ImageAssets.applePie,
        name: "French Apple Pie",
        label: "Minute by tuk tuk",
        rating: 4.9,
        ),
    ItemModel(imagePath: ImageAssets.darkChocolate,
        name: "Dark Chocolate Cake",
        label: "Cakes by Tella",
        rating: 4.9,
        ),
    ItemModel(imagePath: ImageAssets.fudgyChewy,
        name: "Street Shake",
        label: "Café Racer",
        rating: 4.9,
        ),
    ItemModel(imagePath: ImageAssets.streetShake,
        name: "Fudgy Chewy Brownies",
        label: "Minute by tuk tuk",
        rating: 4.9,
        ),
  ];
}