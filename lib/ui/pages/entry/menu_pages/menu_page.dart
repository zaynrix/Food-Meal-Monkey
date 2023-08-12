part of pages;

class MenuPage extends StatefulWidget {
  const MenuPage({Key? key}) : super(key: key);

  @override
  State<MenuPage> createState() => _MenuPageState();
}

class _MenuPageState extends State<MenuPage> {
  final List<MenuModel> menuItem = MenuModel.menuList;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Menu"),
        actions: [
          IconButton(onPressed: () {}, icon: const Icon(Icons.shopping_cart)),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // SearchBar(),
            Stack(
              children: [
                const Align(
                  alignment: Alignment.centerLeft,
                  child: ContainerSide(),
                ),
                SizedBox(
                  height: 500.h,
                  child: ListView.builder(
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: menuItem.length,
                      itemBuilder: (context, index) => TileMenu(
                            title: menuItem[index].title,
                            supTitle: menuItem[index].supTitle,
                            imagePath: menuItem[index].imagePath,
                            onPressed: () {
                              ServiceNavigation.serviceNavi
                                  .pushNamedWidget(RouteGenerator.dessertsPage);
                            },
                          )),
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}
