part of models;

class CategoryModel{
  CategoryModel({required this.imagePath, required this.label});
  final String imagePath;
  final String label;

 static List<CategoryModel> lits = [
   CategoryModel(imagePath: "assets/images/offers.png", label: "Offers"),
   CategoryModel(imagePath: "assets/images/Sri Lankan.png", label: "Sri Lankan"),
   CategoryModel(imagePath: "assets/images/Italian.png", label: "Italian"),
   CategoryModel(imagePath: "assets/images/indian.png", label: "Indian"),
  ];
}