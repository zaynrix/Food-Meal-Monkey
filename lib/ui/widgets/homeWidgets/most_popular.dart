part of widgets;

class MostPopular extends StatelessWidget {
  const MostPopular({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        shrinkWrap: true,
        // physics: const NeverScrollableScrollPhysics(),
        scrollDirection: Axis.horizontal,
        itemCount: ItemModel.mostPopular.length,
        itemBuilder: (context, index) {
          ItemModel data = ItemModel.mostPopular[index];
          return Container(
            padding: EdgeInsetsDirectional.only(start: AppPadding.p20.w),
            width: 228.w,
            height: 185.h,
            child: Column(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              //margin: EdgeInsetsDirectional.only(start: 0, end: 0),
              children: [
                Image.asset(
                  data.imagePath,

                  height: 135.h,
                ),
                addVerticalSpace(AppSize.s12.h),
                Text(
                  data.name,
                  style: Theme.of(context).textTheme.bodyText1!.copyWith(
                      color: primaryFontColor, fontWeight: FontWeight.bold),
                ),
                Row(
                  children: [
                    ItemRating(
                      rating: data.rating,
                    ),
                    SizedBox(
                      width: 3.h,
                    ),
                    Text(
                      '(${data.ratingCount} rating)',
                      style: Theme.of(context).textTheme.caption!.copyWith(
                          color: secondaryFontColor,
                          fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ],
            ),
          );
        });
  }
}
