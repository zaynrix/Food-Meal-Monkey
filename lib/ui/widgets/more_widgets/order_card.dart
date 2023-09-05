part of widgets;


extension CustomBorderSide on BorderSide {
  BorderSide withStatusColor(String status) {
    final Map<String, Color> statusColors = {
      'Shipped': const Color(0xFFC3E4F2),
      'Completed': const Color(0xFFD3EFC3),
      'Canceled': const Color(0xFFFF9D97),
    };

    if (statusColors.containsKey(status)) {
      return copyWith(color: statusColors[status]);
    }
    return this;
  }
}

class OrdersItem extends StatelessWidget {
  const OrdersItem({Key? key, required this.order}) : super(key: key);
  final OrderModel order;

  @override
  Widget build(BuildContext context) {
    final TextTheme textTheme = Theme.of(context).textTheme;
    final String status = order.status;
    final Color? statusColor = getStatusColor(status);

    return Container(
        padding: AppPadding.p16.paddingAll,
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
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Container(
            padding: AppSize.s10.paddingHorizontal,
            decoration: BoxDecoration(
              border: Border(
                left: BorderSide(
                  color: statusColor!,
                  width: 3,
                ).withStatusColor(status),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      status,
                      style: textTheme.bodyLarge,
                    ),
                    const Spacer(),
            Icon(Icons.arrow_forward_ios , size: 15,),
                  ],
                ),
                Text(
                  order.createdAt.convertToFullDate()!,
                  style: textTheme.bodySmall,
                ),
                Text(
                  order.location,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: textTheme.bodySmall!.copyWith(color: secondaryFontColor),
                ),
              ],
            ),
          ),
          AppSize.s16.addVerticalSpace,
          SizedBox(height: 10.height),
          Row(
            children: [
              SizedBox(
                height: 50,
                child: ListView.builder(
                  padding: EdgeInsets.zero,
                  shrinkWrap: true,
                  scrollDirection: Axis.horizontal,
                  itemCount: order.products.length > 3
                      ? 3
                      : order.products.length,
                  itemBuilder: (context, index) {
                    return
                      Transform.translate(
                        offset: Offset(index * -33, 0), // Update the offset here
                        child: Container(
                          padding: 6.paddingAll,
                          margin: const EdgeInsets.all(8),
                          width: 40.width,
                          decoration: BoxDecoration(
                            color: whiteColor,
                            shape: BoxShape.circle,
                            border: Border.all(color: secondaryFontColor),
                          ),
                          child: CachedNetworkImage(
                            imageUrl: order.products[index].imagePath,
                            // height: 80.h,
                            // width: 80.w,
                            fit: BoxFit.cover,
                            placeholder: (context, url) =>
                                Center(child: Image.asset(ImageAssets.app_icon)),
                            errorWidget: (context, url, error) =>
                                Icon(Icons.error),
                          ),
                          // Image.network(order.products[index].imagePath),
                        ),
                      );
                  },
                ),
              ),
              if (order.products.length > 3) ...[
                Transform.translate(
                  offset: Offset(((order.products.length - 3) * -30.0),
                      0), // Update the offset here
                  child: Container(

                    margin: const EdgeInsets.symmetric(horizontal: 4),
                    decoration: const BoxDecoration(
                        color: orangeColor,
                        shape: BoxShape.circle
                      // borderRadius: BorderRadius.circular(10),
                    ),
                    child: Padding(
                      padding: 6.paddingAll,
                      child: Text(
                        '+${order.products.length - 3}',
                        style: textTheme.bodySmall!.copyWith(color: whiteColor , fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ),
              ],
            ],
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              Text(
                order.price,
                style: textTheme.bodyLarge,
              ),
              const Spacer(),
              SizedBox(
                height: 32,
                width: 115,
                child: ElevatedButton(
                  onPressed: () {},
                  child: Text(
                    'Reorder',
                    // style: footNoteRegular(color: ColorManager.white),
                  ),
                ),
              ),
              // Rest of the widget code...
            ],
          ),
        ]));
  }

  Color? getStatusColor(String status) {
    final Map<String, Color> statusColors = {
      'Shipped': const Color(0xFFC3E4F2),
      'Completed': const Color(0xFFD3EFC3),
      'Canceled': const Color(0xFFFF9D97),
      'In Processing': const Color(0xFFC3E4F2),
    };

    if (statusColors.containsKey(status)) {
      return statusColors[status];
    }
    // Return a default color if the status is not recognized
    return Colors.transparent;
  }
}
