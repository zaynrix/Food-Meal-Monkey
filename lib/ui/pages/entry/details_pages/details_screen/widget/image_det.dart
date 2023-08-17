import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:food_delivery_app/resources/styles.dart';

class ImageDet extends StatelessWidget {
  final String? image;

  const ImageDet({this.image});

  @override
  Widget build(BuildContext context) {
    return CachedNetworkImage(
      imageUrl: image!,
      fit: BoxFit.cover,
      placeholder: (context, url) =>
          Center(child: Image.asset(ImageAssets.app_icon)),
      errorWidget: (context, url, error) => Icon(Icons.error),
    );
  }
}
