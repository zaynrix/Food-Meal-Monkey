part of widgets;

class MostPopular extends StatelessWidget {
  const MostPopular({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('most_popular_food')
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return const Text('No data available');
        }
        //DetailsScreen
        return ListView.builder(
          shrinkWrap: true,
          scrollDirection: Axis.horizontal,
          itemCount: snapshot.data!.docs.length,
          itemBuilder: (context, index) {
            DocumentSnapshot doc = snapshot.data!.docs[index];
            String title = doc['name'];
            String rating = doc['rating'];
            String description = doc['description'];
            String imagePath = doc['imagePath'];
            String ratingCount = doc['ratingCount'];

            return GestureDetector(
              onTap: () {
                ServiceNavigation.serviceNavi.pushNamedWidget(
                  RouteGenerator.detailsPage,
                );
              },
              child: Container(
                padding: EdgeInsetsDirectional.only(start: AppPadding.p20.w),
                width: 228.w,
                height: 185.h,
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Image.network(
                      imagePath,
                      height: 135.h,
                    ),
                    addVerticalSpace(AppSize.s12.h),
                    Text(
                      title,
                      style: Theme.of(context).textTheme.bodyText1!.copyWith(
                            color: Colors.black, // Customize text color
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                    Row(
                      children: [
                        ItemRating(rating: rating.toString()),
                        SizedBox(
                          width: 3.h,
                        ),
                        Text(
                          ratingCount,
                          style: const TextStyle(
                            color: Colors.grey, // Customize text color
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }
}
