import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:food_delivery_app/core/model/models.dart';
import 'package:food_delivery_app/ui/pages/entry/details_pages/details_screen/widget/DivLine.dart';
import 'package:food_delivery_app/ui/pages/entry/details_pages/details_screen/widget/Rating_pos.dart';
import 'package:food_delivery_app/ui/pages/entry/details_pages/details_screen/widget/box_options.dart';
import 'package:food_delivery_app/ui/pages/entry/details_pages/details_screen/widget/decrip_det.dart';
import 'package:food_delivery_app/ui/pages/entry/details_pages/details_screen/widget/head_txt.dart';
import 'package:food_delivery_app/ui/pages/entry/details_pages/details_screen/widget/image_det.dart';
import 'package:food_delivery_app/ui/pages/entry/details_pages/details_screen/widget/num_of_portions.dart';
import 'package:food_delivery_app/ui/pages/entry/details_pages/details_screen/widget/total_price.dart';

import '../../../../../routing/navigations.dart';

class DetailsScreen extends StatefulWidget {
  final ProductModel product;

  const DetailsScreen({required this.product, Key? key}) : super(key: key);

  @override
  State<DetailsScreen> createState() => _DetailsScreenState();
}

class _DetailsScreenState extends State<DetailsScreen> {
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
                  onPressed: () {},
                  icon: const Icon(
                    Icons.shopping_cart,
                    color: Colors.white,
                  )),
            ],
            expandedHeight: 300.h,
            pinned: false,
            flexibleSpace: FlexibleSpaceBar(
              background: Hero(
                  tag: widget.product.imagePath,
                  child: ImageDet(image: widget.product.imagePath)),
            ),
          ),
          SliverList(
            delegate: SliverChildListDelegate([
              RatingPos(
                prices: "30",
                rating: widget.product.rating.toString(),
                title: widget.product.name,
              ),
              SizedBox(height: 15),
              HeadTex(str: 'Descriptions'),
              DescriptionDet(description: widget.product.description),
              DevLine(),
              SizedBox(height: 15),
              HeadTex(str: 'Customize your Order'),
              SizedBox(height: 15),
              BoxOptions(str: '- Select the size of portion -'),
              BoxOptions(str: '- Select the ingredients -'),
              SizedBox(height: 15),
              NumOfPortions(),
              SizedBox(height: 35),
              TotalPrice(),
            ]),
          ),
        ],
      ),
      // bottomNavigationBar: const
    );
  }
}
