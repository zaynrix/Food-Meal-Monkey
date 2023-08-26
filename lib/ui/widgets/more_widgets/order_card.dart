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
  const OrdersItem({Key? key, this.element}) : super(key: key);
  final dynamic element;

  @override
  Widget build(BuildContext context) {
    final TextTheme textTheme = Theme.of(context).textTheme;
    final String status = element['status'];
    final Color? statusColor = getStatusColor(status);

    return Container(
        padding: AppPadding.p16.paddingAll,
        decoration: BoxDecoration(
          borderRadius: AppSize.s16.circularRadius,
          color: whiteColor,
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
                  element['date'],
                  style: textTheme.bodySmall,
                ),
                Text(
                  element['address'],
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
                  itemCount: element['elements'].length > 3
                      ? 3
                      : element['elements'].length,
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
                          child: Image.asset(element['elements'][index]['url']),
                        ),
                      );
                  },
                ),
              ),
              if (element['elements'].length > 3) ...[
                Transform.translate(
                  offset: Offset(((element['elements'].length - 3) * -30.0),
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
                        '+${element['elements'].length - 3}',
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
                element['price'],
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
    };

    if (statusColors.containsKey(status)) {
      return statusColors[status];
    }
    // Return a default color if the status is not recognized
    return Colors.transparent;
  }
}
