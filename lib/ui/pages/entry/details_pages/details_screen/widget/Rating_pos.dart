import 'package:flutter/material.dart';
import 'package:food_delivery_app/ui/pages/entry/details_pages/details_screen/widget/shape_rating.dart';
import 'package:food_delivery_app/utils/constant.dart';
import 'package:food_delivery_app/utils/extension/responsive_extension.dart';

class RatingPos extends StatelessWidget {
  final String rating;
  final String title;
  final String prices;
  const RatingPos({
    required this.title,
    required this.rating,
    required this.prices,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          30.addVerticalSpace,
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
              ),
              Container(
                width: 50,
                height: 50,
                decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(color: Colors.black12, offset: Offset(1, 1)),
                      BoxShadow(color: Colors.black12, offset: Offset(-1, -1)),
                    ]),
                // child: SvgPicture.asset(''),
                child: IconButton(
                  onPressed: () {},
                  icon: const Icon(
                    Icons.favorite,
                    color: Color(primaryColor),
                    size: 25,
                  ),
                ),
              ),
            ],
          ),
          10.addVerticalSpace,
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              ShapeRating(
                rating: rating,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    'Rs. $prices',
                    style: TextStyle(
                        fontSize: 31,
                        fontWeight: FontWeight.bold,
                        color: Color(0xff4A4B4D)),
                  ),
                  Text(
                    '/ per Portion',
                    style: TextStyle(color: Color(0xff4A4B4D)),
                  ),
                ],
              )
            ],
          ),
        ],
      ),
    );
  }
}
