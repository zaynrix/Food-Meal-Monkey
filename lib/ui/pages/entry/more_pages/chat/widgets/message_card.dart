import 'package:flutter/material.dart';
import 'package:food_delivery_app/utils/extension/responsive_extension.dart';

Widget messageBubble(
    {required String chatContent,
    required EdgeInsetsGeometry? margin,
    Color? color,
    Color? textColor}) {
  return Container(
    padding: 10.paddingAll,
    margin: margin,
    width: 200.width,
    decoration: BoxDecoration(
      color: color,
      borderRadius: BorderRadius.circular(10.borderRadius),
    ),
    child: Text(
      chatContent,
      style: TextStyle(fontSize: 16.sp, color: textColor),
    ),
  );
}
