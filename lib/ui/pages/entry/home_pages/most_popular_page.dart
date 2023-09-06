part of pages;

class MostPopularPage extends StatelessWidget {
  const MostPopularPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<HomeController>(
      builder: (context, homeController, child) => Scaffold(
        appBar: AppBar(
          title: Text("Most Popular"),
        ),
        body: StreamBuilder<QuerySnapshot>(
          stream: homeController.getAllPopularFoodStream(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }

            if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
              return const Text('No data available');
            }

            final docs = snapshot.data!.docs;
            debugPrint("This is docs for most pobular >>> $docs");
            return Padding(
              padding: AppSize.s5.paddingHorizontal,
              child: GridView.builder(
                shrinkWrap: true,
                scrollDirection: Axis.vertical,
                itemCount: snapshot.data!.docs.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2, // Number of columns in the grid
                  crossAxisSpacing: 0.0, // Spacing between columns
                  mainAxisSpacing: 8.0, // Spacing between rows
                ),
                itemBuilder: (context, index) {
                  final doc = docs[index];
                  final product = ProductModel.fromDocument(doc);
                  return GestureDetector(
                    onTap: () {
                      ServiceNavigation.serviceNavi.pushNamedWidget(
                          RouteGenerator.detailsPage,
                          args: product);
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        boxShadow: [BoxShadow(
                      color: Colors.grey.withOpacity(0.3),
                      // spreadRadius: 1,
                      blurRadius: 15,
                      offset: const Offset(0, 3), // changes position of shadow
                    )],
                      ),
                      // width: 200.w,
                      height: 180.h,
                      child: Card(
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15.0),
                        ),
                        child: Column(
                          mainAxisSize: MainAxisSize.max,
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Hero(
                              tag: product.imagePath,
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(15),
                                child: Center(
                                  child: CachedNetworkImage(
                                    imageUrl: product.imagePath,
                                    height: 135.h,
                                    fit: BoxFit.cover,
                                    placeholder: (context, url) => Center(
                                        child: Image.asset(ImageAssets.app_icon)),
                                    errorWidget: (context, url, error) =>
                                        Icon(Icons.error),
                                  ),
                                ),
                              ),
                            ),
                            addVerticalSpace(AppSize.s12.h),
                            Padding(
                              padding: AppPadding.p8.paddingHorizontal,
                              child: Text(
                                product.name,
                                style:
                                    Theme.of(context).textTheme.bodyLarge!.copyWith(
                                          color: Colors.black,
                                          fontWeight: FontWeight.bold,
                                        ),
                              ),
                            ),
                            Padding(
                              padding: AppPadding.p8.paddingHorizontal,
                              child: Row(
                                children: [
                                  ItemRating(rating: product.rating.toString()),
                                  SizedBox(
                                    width: 3.h,
                                  ),
                                  Text(
                                    product.ratingCount.toString(),
                                    style: const TextStyle(
                                      color: Colors.grey,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            );
          },
        ),
      ),
    );
  }
}
