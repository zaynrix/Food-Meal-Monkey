part of pages;

class OrderDetailScreen extends StatelessWidget {
  const OrderDetailScreen({
    required this.order,
    Key? key}) : super(key: key);
  final int listCount = 10;
  final OrderModel order;


  @override
  Widget build(BuildContext context) {
    final String status = order.status;
    final Color? statusColor = Helpers().getStatusColor(status);
    final TextTheme textTheme = Theme.of(context).textTheme;

    return Consumer<CartController>(
      builder: (context , controller , child) => Scaffold(
        appBar: AppBar(
          title: const Text("Order detail"),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        floatingActionButton: Padding(
          padding: AppPadding.p24.paddingAll,
          child: Container(
            margin: AppSize.s40.marginBottom,
            child: ElevatedButton(
              onPressed: () {},
              child: const Text("Reorder"),
            ),
          ),
        ),
        body: Stack(
          children: [
            Padding(
              padding: AppPadding.p24.paddingHorizontal,
              child: Column(
                children: [
                  Container(
                    decoration: BoxDecoration(
                        borderRadius: AppSize.s15.circularRadius,
                        color: whiteColor),
                    padding: AppSize.s16.paddingAll,
                    child: Container(
                      padding: AppSize.s10.paddingHorizontal,
                      decoration: BoxDecoration(
                          color: whiteColor,
                          border: Border(
                              left: BorderSide(
                                  color: statusColor!, width: 3))),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Text(
                                order.status,
                                style: textTheme.bodyLarge!.copyWith(fontWeight: FontWeight.normal, color: blackColor),
                              ),
                              const Spacer(),
                              SvgPicture.asset(IconAssets.rightBack)
                            ],
                          ),
                          Text(
                            order.createdAt.convertToFullDate()! + "." + order.createdAt.convertToTime()!,
                            style: textTheme.bodySmall!.copyWith(color: blackColor),
                          ),
                          Text(
                            order.location,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: textTheme.bodySmall!.copyWith(color: Colors.grey),
                          )
                        ],
                      ),
                    ),
                  ),
                  AppSize.s24.addVerticalSpace,
                  Expanded(
                    child: Container(
                      padding: EdgeInsets.symmetric(
                          horizontal: AppPadding.p16.width,
                          vertical: AppPadding.p32.height),
                      decoration: BoxDecoration(
                        borderRadius: AppSize.s16.circularRadius,
                        color: whiteColor,
                        boxShadow: [BoxShadow(
                          color: Colors.grey.withOpacity(0.5),
                          // spreadRadius: 1,
                          blurRadius: 15,
                          offset: const Offset(0, 3), // changes position of shadow
                        )]
                      ),
                      child: ListView.builder(
                          shrinkWrap: true,
                          itemCount: order.products.length,
                          itemBuilder: (context, index) {
                            final product = order.products[index];
                            return index != listCount
                                ?  OrderDetailCard(
                              title:
                              product.name,
                              imagePath: product.imagePath,
                              price: product.price.toString(),
                            )
                                : Column(
                              children: [
                                Row(
                                  children: [
                                    Text(
                                      "Sub Total",
                                      style: textTheme.labelMedium!.copyWith(color: primaryFontColor),
                                    ),
                                    const Spacer(),
                                    Text(
                                      "\$90.22",
                                      style: textTheme.bodyLarge,
                                    )
                                  ],
                                ),
                                AppSize.s12.addVerticalSpace,
                                Row(
                                  children: [
                                    Text(
                                      "Delivery",
                                      style: textTheme.bodySmall!.copyWith(color: blackColor),
                                    ),
                                    const Spacer(),
                                    Text(
                                      "Free",
                                      style: textTheme.bodyLarge!.copyWith(color: secondaryFontColor),
                                    )
                                  ],
                                ),
                                AppSize.s12.addVerticalSpace,
                                Row(
                                  children: [
                                    Text(
                                      "Total",
                                      style: textTheme.bodySmall!.copyWith(color: blackColor),
                                    ),
                                    const Spacer(),
                                      Text(
                                      "\$90.22",
                                      style: textTheme.bodyLarge!.copyWith(color: secondaryFontColor),
                                    )
                                  ],
                                ),
                                AppSize.s100.addVerticalSpace
                              ],
                            );
                          }),
                    ),
                  ),
                ],
              ),
            ),
            Positioned(
              bottom: 0,
              child: Container(
                width: 375.width,
                height: 200.height,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: const Alignment(0.00, -1.00),
                    end: const Alignment(0, 1),
                    colors: [Colors.white.withOpacity(0), Colors.white],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
