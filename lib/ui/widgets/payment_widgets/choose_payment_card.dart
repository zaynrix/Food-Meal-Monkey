part of widgets;

class ChoosePaymentCard extends StatelessWidget {
  const ChoosePaymentCard({
    required this.cardNumber,
    required this.cardType,
    required this.isSelected,
    super.key,
    required this.onSelected,
    required this.value,
    required this.currantValue,
  });

  final String cardNumber;
  final String cardType;
  final bool isSelected;
  final void Function(Object?)? onSelected;
  final PaymentCard value;
  final PaymentCard? currantValue;
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: AppSize.s12.marginBottom,
      decoration: BoxDecoration(
          color: moreCardColor,
          borderRadius: BorderRadius.circular(AppSize.s5)),
      padding: EdgeInsets.symmetric(
          horizontal: AppSize.s20.width, vertical: AppSize.s10.height),
      child: Row(
        children: [
          Image.asset(ImageAssets.visaIcon, height: AppSize.s22.height, width: AppSize.s35.width,),
          AppSize.s15.addHorizontalSpace,
          Text("**** **** **** ${cardNumber.substring(cardNumber.length - 4)}"),
          Spacer(),
          Radio(value: value, groupValue: currantValue, onChanged: onSelected)
        ],
      ),
    );
  }
}
