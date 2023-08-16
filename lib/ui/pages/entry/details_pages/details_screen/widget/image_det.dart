import 'package:flutter/material.dart';

class ImageDet extends StatelessWidget {
  final String? image;

  const ImageDet({this.image});

  @override
  Widget build(BuildContext context) {
    return Image.network(
      image!,
      color: Colors.black.withOpacity(0.2),
      colorBlendMode: BlendMode.darken,
      fit: BoxFit.cover,
    );
  }
}
