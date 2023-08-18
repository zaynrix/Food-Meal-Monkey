import 'package:flutter/material.dart';
import 'package:food_delivery_app/resources/styles.dart';
import 'package:food_delivery_app/utils/extension/responsive_extension.dart';

Widget errorContainer() {
  return Container(
    clipBehavior: Clip.hardEdge,
    child: Image.asset(
      ImageAssets.app_icon,
      height: 200.height,
      width: 200.width,
    ),
  );
}
