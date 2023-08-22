import 'package:flutter/material.dart';
import 'package:food_delivery_app/resources/values_manager.dart';
import 'package:food_delivery_app/ui/pages/entry/details_pages/details_screen/widget/cart_button.dart';
import 'package:food_delivery_app/ui/pages/entry/details_pages/details_screen/widget/custom_button_cart.dart';
import 'package:food_delivery_app/ui/pages/entry/details_pages/details_screen/widget/orange_container.dart';
import 'package:food_delivery_app/utils/extension/responsive_extension.dart';

class TotalPrice extends StatelessWidget {
  const TotalPrice({
    required this.onPressed,
    required this.price,
    Key? key,
  }) : super(key: key);

  final double price;
  final void Function()? onPressed;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [OrangeContainer(), CostCard(price: price, onPressed: onPressed,), CartButton()],
    );
  }
}


class CostCard extends StatelessWidget {
  const CostCard({
    required this.onPressed,
    required this.price,
    Key? key,
  }) : super(key: key);

  final double price;
  final void Function()? onPressed;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 40, vertical: 18),
      child: SizedBox(
        width: 330,
        height: 140,
        child: Card(
          elevation: 8,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
              topRight: Radius.circular(10),
              bottomRight: Radius.circular(10),
              bottomLeft: Radius.circular(40),
              topLeft: Radius.circular(40),
            ),
          ),
          child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  'Total Price',
                  style: TextStyle(fontSize: 16, color: Color(0xff4A4B4D)),
                ),
                SizedBox(height: 4),
                Text(
                  'LKR $price',
                  style: TextStyle(
                    fontSize: 21,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                SizedBox(height: AppSize.s5.height),
                CustomButtonCard(onPressed: onPressed,)
              ]),
        ),
      ),
    );
  }
}



