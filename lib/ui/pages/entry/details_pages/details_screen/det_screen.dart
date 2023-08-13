import 'package:flutter/material.dart';
import 'package:food_delivery_app/ui/pages/entry/details_pages/details_screen/widget/DivLine.dart';
import 'package:food_delivery_app/ui/pages/entry/details_pages/details_screen/widget/Rating_pos.dart';
import 'package:food_delivery_app/ui/pages/entry/details_pages/details_screen/widget/box_options.dart';
import 'package:food_delivery_app/ui/pages/entry/details_pages/details_screen/widget/custom_appbar_det.dart';
import 'package:food_delivery_app/ui/pages/entry/details_pages/details_screen/widget/decrip_det.dart';
import 'package:food_delivery_app/ui/pages/entry/details_pages/details_screen/widget/head_txt.dart';
import 'package:food_delivery_app/ui/pages/entry/details_pages/details_screen/widget/image_det.dart';
import 'package:food_delivery_app/ui/pages/entry/details_pages/details_screen/widget/num_of_portions.dart';
import 'package:food_delivery_app/ui/pages/entry/details_pages/details_screen/widget/total_price.dart';
import 'package:food_delivery_app/ui/pages/entry/home_pages/home_Controllers/home_controller.dart';

class DetailsScreen extends StatefulWidget {
  final DetailsScreenArguments arguments;

  const DetailsScreen({required this.arguments, Key? key}) : super(key: key);

  @override
  State<DetailsScreen> createState() => _DetailsScreenState();
}

class _DetailsScreenState extends State<DetailsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      body: Stack(
        alignment: Alignment.center,
        children: [
          ListView(
            children: [
              ImageDet(image: widget.arguments.imagePath),
              RatingPos(
                  rating: widget.arguments.rating,
                  title: widget.arguments.title),
              SizedBox(height: 15),
              HeadTex(str: 'Descriptions'),
              DescriptionDet(description: widget.arguments.description),
              DevLine(),
              SizedBox(height: 15),
              HeadTex(str: 'Customize your Order'),
              SizedBox(height: 15),
              BoxOptions(str: '- Select the size of portion -'),
              BoxOptions(str: '- Select the ingredients -'),
              SizedBox(height: 15),
              NumOfPortions(),
              SizedBox(height: 35),
              TotalPrice()
            ],
          ),
          const CusAppBarDet(),
        ],
      ),
    );
  }
}
