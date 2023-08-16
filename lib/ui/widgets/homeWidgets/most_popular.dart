part of widgets;

class MostPopular extends StatefulWidget {
  final homeController;

  const MostPopular({Key? key, required this.homeController}) : super(key: key);

  @override
  State<MostPopular> createState() => _MostPopularState();
}

class _MostPopularState extends State<MostPopular> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: widget.homeController.getMostPopularFoodStream(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return const Text('No data available');
        }

        return ListView.builder(
          shrinkWrap: true,
          scrollDirection: Axis.horizontal,
          itemCount: snapshot.data!.docs.length,
          itemBuilder: (context, index) {
            DocumentSnapshot doc = snapshot.data!.docs[index];
            String title = widget.homeController.getTitle(doc);
            String rating = widget.homeController.getRating(doc);
            String imagePath = widget.homeController.getImagePath(doc);
            String ratingCount = widget.homeController.getRatingCount(doc);

            return GestureDetector(
              onTap: () {
                widget.homeController.navigateToDetailsPage(context, doc);
              },
              child: Container(
                padding: EdgeInsetsDirectional.only(start: AppPadding.p20.w),
                // width: 200.w,
                height: 185.h,
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Hero(
                      tag: imagePath,
                      child: Image.network(
                        imagePath,
                        height: 135.h,
                        fit: BoxFit.cover,
                      ),
                    ),
                    addVerticalSpace(AppSize.s12.h),
                    Text(
                      title,
                      style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                            color: Colors.black,
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
                            color: Colors.grey,
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
