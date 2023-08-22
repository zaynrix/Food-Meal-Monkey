import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:food_delivery_app/core/controllers/cart_controller/cart_controller.dart';
import 'package:food_delivery_app/core/model/models.dart';
import 'package:food_delivery_app/routing/router.dart';
import 'package:food_delivery_app/ui/pages/entry/details_pages/details_screen/widget/DivLine.dart';
import 'package:food_delivery_app/ui/pages/entry/details_pages/details_screen/widget/Rating_pos.dart';
import 'package:food_delivery_app/ui/pages/entry/details_pages/details_screen/widget/box_options.dart';
import 'package:food_delivery_app/ui/pages/entry/details_pages/details_screen/widget/decrip_det.dart';
import 'package:food_delivery_app/ui/pages/entry/details_pages/details_screen/widget/head_txt.dart';
import 'package:food_delivery_app/ui/pages/entry/details_pages/details_screen/widget/image_det.dart';
import 'package:food_delivery_app/ui/pages/entry/details_pages/details_screen/widget/num_of_portions.dart';
import 'package:food_delivery_app/ui/pages/entry/details_pages/details_screen/widget/total_price.dart';
import 'package:provider/provider.dart';

import '../../../../../routing/navigations.dart';

class DetailsScreen extends StatelessWidget {
  final ProductModel product;

  const DetailsScreen({required this.product, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            leading: IconButton(
              onPressed: () {
                ServiceNavigation.serviceNavi.back();
              },
              icon: const Icon(
                Icons.arrow_back_ios_new_outlined,
                color: Colors.white,
              ),
            ),
            actions: [
              IconButton(
                  onPressed: () {
                    ServiceNavigation.serviceNavi.pushNamedWidget(RouteGenerator.cartPage);
                  },
                  icon: const Icon(
                    Icons.shopping_cart,
                    color: Colors.white,
                  )),
            ],
            expandedHeight: 300.h,
            pinned: false,
            flexibleSpace: FlexibleSpaceBar(
              background: Hero(
                  tag: product.imagePath,
                  child: ImageDet(image: product.imagePath)),
            ),
          ),
          SliverList(
            delegate: SliverChildListDelegate([
              RatingPos(
                prices: "30",
                rating: product.rating.toString(),
                title: product.name,
              ),
              SizedBox(height: 15),
              HeadTex(str: 'Descriptions'),
              DescriptionDet(description: product.description),
              DevLine(),
              SizedBox(height: 15),
              HeadTex(str: 'Customize your Order'),
              SizedBox(height: 15),
              BoxOptions(str: '- Select the size of portion -'),
              BoxOptions(str: '- Select the ingredients -'),
              SizedBox(height: 15),
              NumOfPortions(),
              SizedBox(height: 35),
              Consumer<CartController>(
                builder: (context , controller , child) => TotalPrice(
                  price: product.price.toDouble(),
                  onPressed: (){
                    debugPrint("This is inside ui");
                    controller.addItemToCard(product: product);
                    },
                ),
              ),
            ]),
          ),
        ],
      ),
      // bottomNavigationBar: const
    );
  }
}
