part of models;
class InboxModel {
  InboxModel(
      {required this.title,
      required this.content,
      required this.date,
      required this.isFavorite,
      required this.isRead
      });

  final String title;
  final String date;
  final String content;
  final bool isRead;
  final bool isFavorite;

  static  List<InboxModel> inboxes = [
    InboxModel(title: "MealMonkey Promotions", content: "Lorem ipsum dolor sit amet, consectetur ", date: "6th July", isFavorite: false, isRead: true),
    InboxModel(title: "MealMonkey Promotions", content: "Lorem ipsum dolor sit amet, consectetur ", date: "6th July", isFavorite: false, isRead: false),
    InboxModel(title: "MealMonkey Promotions", content: "Lorem ipsum dolor sit amet, consectetur ", date: "6th July", isFavorite: false, isRead: true),
    InboxModel(title: "MealMonkey Promotions", content: "Lorem ipsum dolor sit amet, consectetur ", date: "6th July", isFavorite: false, isRead: true),
    InboxModel(title: "MealMonkey Promotions", content: "Lorem ipsum dolor sit amet, consectetur ", date: "6th July", isFavorite: false, isRead: false),
    InboxModel(title: "MealMonkey Promotions", content: "Lorem ipsum dolor sit amet, consectetur ", date: "6th July", isFavorite: false, isRead: true),
    InboxModel(title: "MealMonkey Promotions", content: "Lorem ipsum dolor sit amet, consectetur ", date: "6th July", isFavorite: false, isRead: false),
  ];
}
