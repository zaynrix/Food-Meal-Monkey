part of models;

class CategoryModel{
  CategoryModel({required this.imagePath, required this.label});
  final String imagePath;
  final String label;

 static List<CategoryModel> lits = [
   CategoryModel(imagePath: "assets/imags/offers.png", label: "Offers"),
   CategoryModel(imagePath: "assets/imags/Sri Lankan.png", label: "Sri Lankan"),
   CategoryModel(imagePath: "assets/imags/Italian.png", label: "Italian"),
   CategoryModel(imagePath: "assets/imags/indian.png", label: "Indian"),
  ];
}