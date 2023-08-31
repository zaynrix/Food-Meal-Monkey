part of pages;

class PaymentDetailsPage extends StatefulWidget {
  const PaymentDetailsPage({Key? key}) : super(key: key);

  @override
  State<PaymentDetailsPage> createState() => _PaymentDetailsPageState();
}

class _PaymentDetailsPageState extends State<PaymentDetailsPage> {

  @override
  void initState() {
    super.initState();
    Provider.of<PaymentController>(context , listen: false).fetchPaymentCards();
  }

  @override
  Widget build(BuildContext context) {
    final TextTheme textTheme = Theme.of(context).textTheme;
    return Scaffold(
      appBar: AppBar(
        title: Text("Payment Details"),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: AppPadding.p24.paddingHorizontal,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Customize your payment method",
                style: textTheme.titleMedium,
              ),
              AppSize.s16.addVerticalSpace,
              Divider(
                color: primaryFontColor,
              ),
              AppSize.s15.addVerticalSpace,
              Consumer<PaymentController>(
                builder: (context, controller, child) => ListView.builder(
                  physics: NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                    itemCount: controller.paymentCards.length,
                    itemBuilder: (context, index) {
                      final card = controller.paymentCards[index];
                      return PaymentCardWidget(
                        onTap: (){
                          controller.deleteCard(card);
                        },
                          imagePath: ImageAssets.visaIcon,
                          supTitle: "**** ****     ${card.number.substring(card.number.length - 4)}",
                          title: card.name);
                    }),
              ),
              AppSize.s50.addVerticalSpace,
              CustomButton(text: "Add Another Credit/Debit Card", onPress: (){
                ServiceNavigation.serviceNavi.pushNamedWidget(RouteGenerator.addPaymentPage);
              })
            ],
          ),
        ),
      ),
    );
  }
}
