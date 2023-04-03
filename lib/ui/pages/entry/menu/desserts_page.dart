import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:food_delivery_app/routing/navigations.dart';

import '../../../../resources/styles.dart';
import '../../../../resources/values_manager.dart';
import '../../../widgets/widgets.dart';

class DesertsPage extends StatelessWidget {
  const DesertsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Desserts"),
        leading: IconButton(onPressed: (){ServiceNavigation.serviceNavi.back();}, icon: const Icon(Icons.arrow_back_ios_new_outlined)),
        actions: [
          IconButton(onPressed: (){}, icon: const Icon(Icons.shopping_cart))
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              // padding: EdgeInsetsDirectional.only(start: AppPadding.p20.w),
              height: AppSize.s200.h,
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage(ImageAssets.applePie,),
                  fit: BoxFit.fill
                )
              ),
              child:  Align(
                alignment: Alignment.bottomLeft,
                child: Padding(
                  padding: EdgeInsetsDirectional.only(bottom: AppPadding.p25.h, start: AppPadding.p20.w),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text("French Apple Pie", style: Theme.of(context).textTheme.subtitle1,),
                        vSpace5,
                        Row(
                          children: [
                            const ItemRating(
                              rating: 4,
                            ),
                          ],
                        )
                      ],
                    )),
              ),
            )
          ],
        ),
      )
    );
  }
}
