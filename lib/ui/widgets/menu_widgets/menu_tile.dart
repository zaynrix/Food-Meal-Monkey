import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../resources/styles.dart';
import '../../../resources/values_manager.dart';

class TileMenu extends StatelessWidget {
  const TileMenu({
    Key? key,
    required this.title,
    required this.supTitle,
    required this.imagePath,
    required this.onPressed,
  }) : super(key: key);

  final String title;
  final String supTitle;
  final String imagePath;
  final Function()? onPressed;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPressed,
      child: Container(
        width: AppSize.s280.w,
        height: AppSize.s87.h,
        margin: EdgeInsetsDirectional.only(start: AppMargin.m50.w, end: AppMargin.m50.w,
        top:  AppMargin.m24.w),
        decoration: BoxDecoration(
            color: whiteColor,
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(AppSize.s30.r),
                bottomLeft: Radius.circular(AppSize.s30.r),
                topRight: Radius.circular(AppSize.s10.r),
                bottomRight: Radius.circular(AppSize.s10.r)),
            boxShadow:  [
              BoxShadow(blurRadius: AppSize.s10.r, color: placeholderBg)
            ]),
        child: Row(
          children: [
            Transform.translate(

                offset:  Offset(-40.w, 0),
                child: Image.asset(imagePath)),

            Transform.translate(
              offset: Offset(-30.w, 0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children:  [
                  Text(title, style: Theme.of(context).textTheme.headline4,),
                  Text(supTitle, style: Theme.of(context).textTheme.headline6,),
                ],
              ),
            ),
            const Spacer(),
            Transform.translate(
              offset: Offset(AppSize.s25.w, 0),
              child: Container(
                height: 40.h,

                decoration: BoxDecoration(
                    color: whiteColor,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(blurRadius: AppSize.s10.r, color: placeholderBg)
                    ]),
                child: IconButton(
                  icon: const Icon(
                    Icons.arrow_forward_ios,
                    color: orangeColor,
                  ),
                  onPressed: () {},
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
