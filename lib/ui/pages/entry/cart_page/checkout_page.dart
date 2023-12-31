part of pages;

class CheckoutPage extends StatefulWidget {
  const CheckoutPage({Key? key}) : super(key: key);

  @override
  State<CheckoutPage> createState() => _CheckoutPageState();
}

class _CheckoutPageState extends State<CheckoutPage> {
  @override
  void initState() {
    super.initState();
    Provider.of<PaymentController>(context, listen: false).fetchPaymentCards();
    Provider.of<LocationController>(context, listen: false).getUserLocation();
  }

  @override
  Widget build(BuildContext context) {
    final TextTheme textTheme = Theme.of(context).textTheme;
    return Consumer3<PaymentController , CartController , LocationController>(
      builder: (context, payment, cart , location , child) => Scaffold(
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: SingleChildScrollView(
        child: Padding(
          padding: AppSize.s24.paddingAll,
          child: CustomButton(
            onPress: () {
              cart.makeOrder();
            },
            text: "Send order",
          ),
        ),
      ),
      appBar: AppBar(
        title: Text("Checkout"),
      ),
      body: Padding(
        padding: AppPadding.p24.paddingHorizontal,
        child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Delivery Address",
                style: textTheme.titleSmall,
              ),
              AppSize.s16.addVerticalSpace,
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SizedBox(
                    width: FlutterSizes.screenDeviceHeight * 0.2,
                    child: Text(
                      location.userAddress,
                      style: textTheme.titleMedium!.copyWith(fontSize: 15),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      ServiceNavigation.serviceNavi.pushNamedWidget(RouteGenerator.changeLocationScreen);
                    },
                    child: Text("Change",
                        style: textTheme.headlineSmall!
                            .copyWith(color: orangeColor)),
                  )
                ],
              ),
              AppSize.s10.addVerticalSpace,
              Divider(
                color: primaryFontColor,
              ),
              AppSize.s10.addVerticalSpace,
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Payment method",
                    style: textTheme.labelMedium,
                  ),
                  TextButton(
                      onPressed: () {
                        ServiceNavigation.serviceNavi
                            .pushNamedWidget(RouteGenerator.addPaymentPage);
                      },
                      child: Text(
                        "+ Add Card",
                        style: textTheme.headlineSmall!
                            .copyWith(color: orangeColor),
                      ))
                ],
              ),
              ListView.builder(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: payment.paymentCards.length,
                  itemBuilder: (context, index) {
                    final card = payment.paymentCards[index];
                    return ChoosePaymentCard(
                      value: card,
                      cardNumber: card.number,
                      cardType: card.type,
                      isSelected: false,
                      onSelected: (value){
                        payment.onSelectedCard(card: value as PaymentCard);
                      },
                      currantValue: payment.currantCard,
                    );
                  }),
              AppSize.s30.addVerticalSpace,
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Sub Total",
                    style: textTheme.titleSmall,
                  ),
                  Text(
                    cart.calculateSubtotal(),
                    style: textTheme.titleMedium,
                  )
                ],
              ),
              AppSize.s12.addVerticalSpace,
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Delivery Cost",
                    style: textTheme.titleSmall,
                  ),
                  Text(
                    "Free",
                    style: textTheme.titleMedium,
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
