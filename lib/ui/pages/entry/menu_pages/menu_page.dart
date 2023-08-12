part of pages;

class MenuPage extends StatefulWidget {
  const MenuPage({Key? key}) : super(key: key);

  @override
  State<MenuPage> createState() => _MenuPageState();
}

class _MenuPageState extends State<MenuPage> {
  final List<MenuModel> menuItem = MenuModel.menuList;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

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
                  child: StreamBuilder<QuerySnapshot>(
                    stream: _firestore.collection('menu').snapshots(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return CircularProgressIndicator();
                      }
                      if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                        return Text('No menu items available');
                      }
                      return ListView.builder(
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: snapshot.data!.docs.length,
                        itemBuilder: (context, index) {
                          final menuData = snapshot.data!.docs[index].data()
                              as Map<String, dynamic>;
                          return TileMenu(
                            title: menuData['name'],
                            supTitle: menuData['itemsCount'],
                            imagePath: menuData['imagePath'],
                            onPressed: () {
                              ServiceNavigation.serviceNavi
                                  .pushNamedWidget(RouteGenerator.dessertsPage);
                            },
                          );
                        },
                      );
                    },
                  ),
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}
