import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../resources/styles.dart';
import '../../resources/values_manager.dart';
class ContainerSide extends StatelessWidget {
  const ContainerSide({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 485.h,
      width: 97.w,
      decoration: BoxDecoration(
          color: orangeColor,
          borderRadius: BorderRadius.only(topRight: Radius.circular(AppSize.s38.r), bottomRight: Radius.circular(AppSize.s38.r))
      ),
    );
  }
}