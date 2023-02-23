part of models;

class MainMenu {
  MainMenu({required this.index, this.icon, this.label , this.isBlank = false});
  final int index;
  final IconData? icon;
  final String? label;
  final bool isBlank;

  static List<MainMenu> list = [
    MainMenu(index: 0, icon: Icons.menu, label: 'Menu'),
    MainMenu(index: -1, isBlank: true),
    MainMenu(index: 1, icon: Icons.shopping_bag, label: 'Offers'),
    MainMenu(index: 2, icon: Icons.person, label: 'Profile'),
    MainMenu(index: 3, icon: Icons.format_indent_decrease, label: 'More'),
  ];
}