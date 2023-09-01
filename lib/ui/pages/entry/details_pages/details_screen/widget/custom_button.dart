import 'package:flutter/material.dart';
import 'package:food_delivery_app/utils/constant.dart';

class CustomButtonDetails extends StatelessWidget {
  final String str;
  final int count;
  final void Function()? onPressed;

  CustomButtonDetails(
      {required this.onPressed,
      super.key,
      required this.count,
      required this.str});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 30,
      width: 52,
      child: ElevatedButton(
          style: ButtonStyle(
            shape: MaterialStateProperty.all(
              RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
            ),
            backgroundColor:
                MaterialStateProperty.all(const Color(primaryColor)),
          ),
          onPressed: onPressed,
          child: Text(
            str,
            style: const TextStyle(fontSize: 18),
          )),
    );
  }
}
