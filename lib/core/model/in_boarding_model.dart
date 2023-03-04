part of models;

class InBoardingModel{
  InBoardingModel({required this.imagePath, required this.title, required this.desc});
  final String imagePath;
  final String title;
  final String desc;

  static List<InBoardingModel> data = [
    InBoardingModel(
      imagePath: 'assets/images/intro1.png',
      title: 'Find Food You Love',
      desc: 'Discover the best foods from over 1,000 restaurants and fast delivery to your doorstep'
    ),
    InBoardingModel(
      imagePath: 'assets/images/intro2.png',
      title: 'Fast Delivery',
      desc: 'Fast food delivery to your home, office wherever you are'
    ),
    InBoardingModel(
      imagePath: 'assets/images/intro3.png',
      title: 'Live Tracking',
      desc: 'Real time tracking of your food on the app once you placed the order'
    ),
  ];
}
