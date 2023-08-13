import 'package:flutter/material.dart';
import 'package:food_delivery_app/utils/constant.dart';

class CustomButtonDetails extends StatefulWidget {
  final String str;
  int count;

  CustomButtonDetails({super.key, required this.count, required this.str});

  @override
  State<CustomButtonDetails> createState() => _CustomButtonDetailsState();
}

class _CustomButtonDetailsState extends State<CustomButtonDetails> {
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
          onPressed: () {
            setState(() {
              widget.str == '+' ? widget.count++ : widget.count--;
            });
          },
          child: Text(
            widget.str,
            style: const TextStyle(fontSize: 18),
          )),
    );
  }
}
