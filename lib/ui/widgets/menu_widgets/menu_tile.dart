// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
//
// import '../../../resources/styles.dart';
// import '../../../resources/values_manager.dart';
//
// class TileMenu extends StatelessWidget {
//   const TileMenu({
//     Key? key,
//     required this.title,
//     required this.supTitle,
//     required this.imagePath,
//     required this.onPressed,
//   }) : super(key: key);
//
//   final String title;
//   final String supTitle;
//   final String imagePath;
//   final Function()? onPressed;
//
//   @override
//   Widget build(BuildContext context) {
//     return InkWell(
//       onTap: onPressed,
//       child: Container(
//         width: AppSize.s280.w,
//         height: AppSize.s87.h,
//         margin: EdgeInsetsDirectional.only(
//             start: AppMargin.m50.w, end: AppMargin.m50.w, top: AppMargin.m24.w),
//         decoration: BoxDecoration(
//             color: whiteColor,
//             borderRadius: BorderRadius.only(
//                 topLeft: Radius.circular(AppSize.s30.r),
//                 bottomLeft: Radius.circular(AppSize.s30.r),
//                 topRight: Radius.circular(AppSize.s10.r),
//                 bottomRight: Radius.circular(AppSize.s10.r)),
//             boxShadow: [
//               BoxShadow(blurRadius: AppSize.s10.r, color: placeholderBg)
//             ]),
//         child: Row(
//           children: [
//             Transform.translate(
//               offset: Offset(-40.w, 0),
//               child: ClipOval(
//                 child: Image.network(
//                   imagePath,
//                   height: 70.h,
//                   // width: 140.w,
//                   fit: BoxFit.cover,
//                   errorBuilder: (context, error, stackTrace) => Container(
//                     height: 100.h,
//                     width: 100.w,
//                     color: Colors.grey,
//                   ),
//                 ),
//               ),
//             ),
//             Transform.translate(
//               offset: Offset(-30.w, 0),
//               child: Column(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Text(
//                     title,
//                     style: Theme.of(context).textTheme.headlineMedium,
//                   ),
//                   Text(
//                     "$supTitle items",
//                     style: Theme.of(context).textTheme.titleLarge,
//                   ),
//                 ],
//               ),
//             ),
//             const Spacer(),
//             Transform.translate(
//               offset: Offset(AppSize.s25.w, 0),
//               child: Container(
//                 height: 40.h,
//                 decoration: BoxDecoration(
//                     color: whiteColor,
//                     shape: BoxShape.circle,
//                     boxShadow: [
//                       BoxShadow(blurRadius: AppSize.s10.r, color: placeholderBg)
//                     ]),
//                 child: IconButton(
//                   icon: const Icon(
//                     Icons.arrow_forward_ios,
//                     color: orangeColor,
//                   ),
//                   onPressed: () {},
//                 ),
//                 //
//               ),
//             )
//           ],
//         ),
//       ),
//     );
//   }
// }

import 'package:cached_network_image/cached_network_image.dart';
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
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: AppMargin.m16,
        vertical: AppMargin.m8,
      ),
      child: GestureDetector(
        onTap: onPressed,
        child: Container(
          width: AppSize.s280.w,
          height: AppSize.s87.h,
          decoration: BoxDecoration(
            color: whiteColor,
            borderRadius: BorderRadius.circular(AppSize.s85.r),
            boxShadow: [
              BoxShadow(blurRadius: AppSize.s10.r, color: Colors.grey.shade200),
            ],
          ),
          child: Row(
            children: [
              Container(
                width: 70.h, // Set a fixed width for the image container
                height: 70.h, // Set a fixed height for the image container
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(blurRadius: AppSize.s10.r, color: placeholderBg),
                  ],
                ),
                child: ClipOval(
                  child: CachedNetworkImage(
                    imageUrl: imagePath,
                    fit: BoxFit.cover,
                    width: double.infinity,
                    placeholder: (context, url) => Center(
                        child: FittedBox(
                            child: Image.asset(ImageAssets.app_icon))),
                    errorWidget: (context, url, error) => Icon(Icons.error),
                  ),
                ),
              ),
              SizedBox(
                  width: 10.w), // Add some spacing between the image and text
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: Theme.of(context).textTheme.headlineMedium,
                  ),
                  Text(
                    "$supTitle items",
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                ],
              ),
              Spacer(),
              Container(
                width: 40.h, // Set a fixed width for the IconButton container
                height: 40.h, // Set a fixed height for the IconButton container
                decoration: BoxDecoration(
                  color: whiteColor,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(blurRadius: AppSize.s10.r, color: placeholderBg),
                  ],
                ),
                child: IconButton(
                  icon: const Icon(
                    Icons.arrow_forward_ios,
                    color: orangeColor,
                  ),
                  onPressed: onPressed,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
