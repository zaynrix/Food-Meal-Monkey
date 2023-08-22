import 'package:food_delivery_app/utils/constant.dart';
import 'package:flutter/material.dart';
class CustomButtonCard extends StatelessWidget {
  const CustomButtonCard({
    required this.onPressed,
    Key? key,
  }) : super(key: key);

  final void Function()? onPressed;
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 165,
      height: 38,
      child: ElevatedButton(
        onPressed: onPressed,
        style: const ButtonStyle(
            backgroundColor: MaterialStatePropertyAll(Color(primaryColor)),
            shape: MaterialStatePropertyAll(
              RoundedRectangleBorder(
                borderRadius: BorderRadius.all(
                  Radius.circular(28),
                ),
              ),
            )),
        child: const Row(
          children: [
            Icon(Icons.add_shopping_cart_outlined),
            SizedBox(width: 4),
            FittedBox(child: Text('Add to Cart')),
          ],
        ),
      ),
    );
  }
}
