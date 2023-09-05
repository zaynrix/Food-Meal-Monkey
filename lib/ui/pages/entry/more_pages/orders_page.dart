part of pages;

class OrdersPage extends StatefulWidget {
  OrdersPage({Key? key}) : super(key: key);

  @override
  State<OrdersPage> createState() => _OrdersPageState();
}

class _OrdersPageState extends State<OrdersPage> {
  @override
  void initState() {
    super.initState();
    sl<OrderController>().fetchOrders();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Orders"),
      ),
      body: Consumer<OrderController>(
        builder: (context, controller, child) => Stack(
          children: [
            GroupedListView<dynamic, String>(
              elements: controller.orders,
              groupBy: (element) =>
                  element.createdAt.toString().differenceDay()!,
              groupComparator: (value1, value2) => value2.compareTo(value1),
              order: GroupedListOrder.ASC,
              // useStickyGroupSeparators: true,
              groupSeparatorBuilder: (value) => Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20.0, vertical: 8),
                    child: Text(
                      value,
                      textAlign: TextAlign.left,
                      style: const TextStyle(
                          fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                  ),
                  Divider(
                    color: primaryFontColor,
                  )
                ],
              ),
              itemBuilder: (context, element) => Column(
                children: [
                  InkWell(
                    onTap: () {},
                    child: Padding(
                      padding: AppPadding.p24.paddingHorizontal,
                      child: OrdersItem(
                        order: element,
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                ],
              ),
            ),
            Visibility(
              visible: controller.isLoading,
              child: Container(
                height: FlutterSizes.screenDeviceHeight,
                width: FlutterSizes.screenDeviceWidth,
                color: secondaryFontColor.withOpacity(0.3),
                child: const LoadingStatusWidget(
                  loadingStatus: LoadingStatusOption.loading,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

}
