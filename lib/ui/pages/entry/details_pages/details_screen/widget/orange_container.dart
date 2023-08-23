import 'package:flutter/material.dart';
import 'package:food_delivery_app/utils/constant.dart';

class OrangeContainer extends StatelessWidget {
  const OrangeContainer({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 180,
      width: 95,
      decoration: const BoxDecoration(
        color: Color(primaryColor),
        borderRadius: BorderRadius.only(
          topRight: Radius.circular(38),
          bottomRight: Radius.circular(38),
        ),
      ),
    );
  }
}
