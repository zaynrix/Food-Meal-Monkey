part of widgets;

class RecentItems extends StatelessWidget {
   RecentItems({Key? key}) : super(key: key);
  final data = ItemModel.recentItem;
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemCount: ItemModel.recentItem.length,
        itemBuilder: (context, index) =>
            Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: SizedBox(
                width: 80.w,
                height: 80.h,
                child: Image.asset(data[index].imagePath),
              ),
            ),
             SizedBox(
              width: 10.h,
            ),
            Expanded(
              child: SizedBox(
                height: 100.h,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      data[index].name,
                      style: Theme.of(context).textTheme
                          .headline4!
                          .copyWith(color: primaryFontColor),
                    ),
                    Row(
                      children:  [
                        const Text("Cafe"),
                        SizedBox(
                          width: 5.w,
                        ),
                        const Padding(
                          padding:  EdgeInsets.only(bottom: 5.0),
                          child: Text(
                            ".",
                            style: TextStyle(
                              color: orangeColor,
                              fontWeight: FontWeight.w900,
                            ),
                          ),
                        ),
                         SizedBox(
                          width: 5.w,
                        ),
                        const Text("Western Food"),
                         SizedBox(
                          width: 20.w,
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        ItemRating(
                          rating: data[index].rating,
                        ),
                        SizedBox(
                          width: 3.h,
                        ),
                        Text(
                          '(${data[index].ratingCount} rating)',
                          style: Theme.of(context).textTheme.caption!.copyWith(
                              color: secondaryFontColor,
                              fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            )
          ],
        )
    );
  }
}
