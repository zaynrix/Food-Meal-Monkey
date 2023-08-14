import 'package:flutter/material.dart';
import 'package:food_delivery_app/utils/constant.dart';

class ImageDet extends StatelessWidget {
  final String? image;

  const ImageDet({this.image});

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.bottomRight,
      children: [
        Column(
          children: [
            SizedBox(
              width: double.infinity,
              height: 360,
              child: ClipRRect(
                borderRadius: const BorderRadius.only(
                    bottomLeft: Radius.circular(50),
                    bottomRight: Radius.circular(50)),
                child: Image.network(
                  image!,
                  color: Colors.black.withOpacity(0.2),
                  colorBlendMode: BlendMode.darken,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            const SizedBox(
              height: 38,
              width: double.infinity,
            ),
          ],
        ),
        Positioned(
          bottom: 0,
          right: 35,
          child: Container(
            width: 70,
            height: 70,
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
                size: 40,
              ),
            ),
          ),
        )
      ],
    );
  }
}