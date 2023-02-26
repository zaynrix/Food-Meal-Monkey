part of widgets;

class PupularResturent extends StatelessWidget {
  const PupularResturent({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        physics: const NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        itemCount: ItemModel.popularRestaurents.length,
        itemBuilder: (context, index) {
          ItemModel data = ItemModel.popularRestaurents[index];
          return Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            //margin: EdgeInsetsDirectional.only(start: 0, end: 0),
            children: [
              Image.asset(
                data.imagePath,
                fit: BoxFit.fitWidth,
                width: double.infinity,
              ),
              addVerticalSpace(AppSize.s10.h),
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
                  addHorizantelSpace(AppSize.s5.w),
                  Text(
                    '(${data.ratingCount} rating)',
                    style: Theme.of(context).textTheme.caption!.copyWith(
                        color: secondaryFontColor,
                        fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              addVerticalSpace(AppSize.s30.h)
            ],
          );
        });
  }
}
