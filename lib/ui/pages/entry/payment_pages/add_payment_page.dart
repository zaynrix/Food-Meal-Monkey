part of pages;

class PaymentPage extends StatefulWidget {
  PaymentPage({Key? key}) : super(key: key);

  @override
  State<PaymentPage> createState() => _PaymentPageState();
}

class _PaymentPageState extends State<PaymentPage> {
  final TextEditingController cardNumberController = TextEditingController();
  final TextEditingController fullNameController = TextEditingController();
  final TextEditingController cvvController = TextEditingController();
  final TextEditingController dateController = TextEditingController();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    cardNumberController.addListener(() {
      Provider.of<PaymentController>(context, listen: false)
          .getCardTypeFrmNum(cardNumber: cardNumberController.text);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: Text("Payment"),
      ),
      body: SafeArea(
        child: Padding(
          padding: AppPadding.p24.paddingHorizontal,
          child: Form(
            key: formKey,
            child: Column(
              children: [
                AppSize.s40.addVerticalSpace,
                Consumer<PaymentController>(
                  builder: (context, controller, child) => MainTextField(
                    controller: cardNumberController,
                    validator: (value) => CardUtils.validateCardNum(value),
                    text: "Card Number",
                    type: TextInputType.number,
                    suffixIcon: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: CardUtils.getCardIcon(controller.cardType),
                    ),
                    prefixIcon: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: SvgPicture.asset(IconAssets.cardIcon),
                    ),
                    inputFormatters: [
                      FilteringTextInputFormatter.digitsOnly,
                      LengthLimitingTextInputFormatter(19),
                      CardNumberInputFormat()
                    ],
                  ),
                ),
                AppSize.s20.addVerticalSpace,
                MainTextField(
                  validator: (value) => value!.validateUserName(),
                  text: "Full Name",
                  type: TextInputType.name,
                  controller: fullNameController,
                  prefixIcon: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: SvgPicture.asset(IconAssets.userIcon),
                  ),
                ),
                AppSize.s20.addVerticalSpace,
                Row(
                  children: [
                    Expanded(
                      child: MainTextField(
                        controller: cvvController,
                        validator: (value) => CardUtils.validateCVV(value),
                        text: 'CVV',
                        inputFormatters: [
                          LengthLimitingTextInputFormatter(3),
                          FilteringTextInputFormatter.digitsOnly,
                        ],
                        prefixIcon: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: SvgPicture.asset(IconAssets.cvvIcon),
                        ),
                        type: TextInputType.number,
                      ),
                    ),
                    AppSize.s15.addHorizontalSpace,
                    Expanded(
                      child: MainTextField(
                        controller: dateController,
                        validator: (value) => CardUtils.validateDate(value),
                        text: "MM/YY",
                        inputFormatters: [
                          LengthLimitingTextInputFormatter(5),
                          FilteringTextInputFormatter.digitsOnly,
                          CardMonthInputFormatter(),
                        ],
                        prefixIcon: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: SvgPicture.asset(IconAssets.calenderIcon),
                        ),
                        type: TextInputType.datetime,
                      ),
                    ),
                  ],
                ),
                AppSize.s40.addVerticalSpace,
                Consumer<PaymentController>(
                  builder: (context, controller, child) => CustomButton(
                      text: "Add Card",
                      onPress: () {
                        if (formKey.currentState!.validate()) {
                          controller.addNewCard(card: PaymentCard(
                            number: cardNumberController.text,
                            name: fullNameController.text,
                            cvv: cvvController.text,
                            type: controller.cardType.name.toString(),
                            date: dateController.text.cardSyntaxToFullDate(),

                          ));
                        }
                      }),
                ),
                AppSize.s40.addVerticalSpace,
              ],
            ),
          ),
        ),
      ),
    );
  }
}
