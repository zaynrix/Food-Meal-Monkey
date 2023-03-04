import '../../resources/styles.dart';

class MenuModel{
  MenuModel({required this.title, required this.supTitle, required this.imagePath});
  final String title;
  final String supTitle;
  final String imagePath;

   static final List<MenuModel> menuList = [
     MenuModel(title: "Food", supTitle: "120 items", imagePath: ImageAssets.foodMenu),
     MenuModel(title: "Beverages", supTitle: "220 Items", imagePath: ImageAssets.beveragesMenu),
     MenuModel(title: "Desserts", supTitle: "155 Items", imagePath: ImageAssets.dessertsMenu),
     MenuModel(title: "Promotions", supTitle: "25 Items", imagePath: ImageAssets.promotionsMenu),
   ];
}