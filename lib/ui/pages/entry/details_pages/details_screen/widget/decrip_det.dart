import 'package:flutter/material.dart';
import 'package:food_delivery_app/utils/constant.dart';

class DescriptionDet extends StatelessWidget {
  final String description;
  const DescriptionDet({
    required this.description,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(15),
      child: Text(
        description,
        style: TextStyle(
          fontSize: 16,
          color: Color(secondaryTextColor),
        ),
      ),
    );
  }
}
