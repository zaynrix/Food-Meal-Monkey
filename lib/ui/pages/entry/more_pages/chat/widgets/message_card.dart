import 'package:flutter/material.dart';
import 'package:food_delivery_app/utils/extension/responsive_extension.dart';

Widget messageBubbleText(
    {required String chatContent,
    required EdgeInsetsGeometry? margin,
    required String? timeStamp,
    required bool isSender,
    Color? color,
    Color? textColor}) {
  return Column(
    crossAxisAlignment:
        isSender ? CrossAxisAlignment.start : CrossAxisAlignment.end,
    children: [
      Container(
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
      ),
      // 5.addVerticalSpace,
      Container(
        padding: 10.paddingAll,
        child: Text(
          timeStamp!,
          textAlign: TextAlign.start,
          style: const TextStyle(
              color: Colors.grey, fontSize: 12, fontStyle: FontStyle.italic),
        ),
      )
    ],
  );
}
