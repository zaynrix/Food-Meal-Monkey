part of pages;

class OffersPage extends StatefulWidget {
  const OffersPage({Key? key}) : super(key: key);

  @override
  State<OffersPage> createState() => _OffersPageState();
}

class _OffersPageState extends State<OffersPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Latest offers"),
        actions: [
          IconButton(onPressed: () {}, icon: const Icon(Icons.shopping_cart))
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsetsDirectional.only(start: AppPadding.p20.w),
              child:
                  const Text("Find discounts, Offers special\n meals and more!"),
            ),
            addVerticalSpace(AppSize.s24.h),
            Container(
              margin: EdgeInsetsDirectional.only(start: AppPadding.p20.w),
              height: AppSize.s30.h,
              width: AppSize.s155.w,
              child: ElevatedButton(
                onPressed: () {},
                child: const Text("Check offers"),
              ),
            ),
            addVerticalSpace(AppSize.s22.h),
            ListView.builder(
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemCount: ItemModel.popularRestaurents.length,
                itemBuilder: (context, index) {
                  ItemModel data = ItemModel.popularRestaurents[index];
                  return Column(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Image.asset(
                        data.imagePath,
                        fit: BoxFit.fitWidth,
                        width: double.infinity,
                      ),
                      addVerticalSpace(AppSize.s10.h),
                      Container(
                        margin: EdgeInsetsDirectional.only(start: AppPadding.p20.w),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
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
                                addHorizontalSpace(AppSize.s5.w),
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
                      ),

                      addVerticalSpace(AppSize.s30.h)
                    ],
                  );
                })
          ],
        ),
      ),
    );
  }
}
