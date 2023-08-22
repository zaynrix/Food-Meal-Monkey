import 'package:flutter/material.dart';
import 'package:food_delivery_app/routing/navigations.dart';
import 'package:food_delivery_app/routing/router.dart';
import 'package:food_delivery_app/utils/constant.dart';

class CartButton extends StatelessWidget {
  const CartButton({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: 65,
      right: 43,
      child: Container(
        width: 47,
        height: 47,
        decoration: const BoxDecoration(boxShadow: [
          BoxShadow(color: Colors.black12, offset: Offset(1.5, 1.5)),
          BoxShadow(color: Colors.black12, offset: Offset(-1.5, -1.5)),
        ], shape: BoxShape.circle, color: Colors.white),
        child: IconButton(
          onPressed: () {
            ServiceNavigation.serviceNavi
                .pushNamedWidget(RouteGenerator.cartPage);
          },
          icon: const Icon(
            Icons.shopping_cart,
            color: Color(primaryColor),
            size: 25,
          ),
        ),
      ),
    );
  }
}
