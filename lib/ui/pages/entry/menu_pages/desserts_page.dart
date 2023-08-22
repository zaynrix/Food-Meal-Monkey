part of pages;

class DessertsPage extends StatelessWidget {
  DessertsPage({Key? key}) : super(key: key);

  final List<ProductModel> dessertsItem = ProductModel.desserts;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Desserts"),
          leading: IconButton(
              onPressed: () {
                ServiceNavigation.serviceNavi.back();
              },
              icon: const Icon(Icons.arrow_back_ios_new_outlined)),
          actions: [
            IconButton(
                onPressed: () {
                  ServiceNavigation.serviceNavi.back();
                },
                icon: const Icon(Icons.shopping_cart))
          ],
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              // const SearchBar(),
              ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: dessertsItem.length,
                  itemBuilder: (context, index) {
                    final dessert = dessertsItem[index];
                    return DessertsWidget(
                      title: dessert.name,
                      imagePath: dessert.imagePath,
                      // label: dessert.label,
                      rate: dessert.rating.toDouble(),
                    );
                  }),
              // DessertsWidget()
            ],
          ),
        ));
  }
}
