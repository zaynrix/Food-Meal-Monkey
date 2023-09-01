import 'package:flutter/material.dart';
import 'package:food_delivery_app/ui/pages/entry/details_pages/details_screen/widget/show_result.dart';

import 'custom_button.dart';
import 'head_txt.dart';

class NumOfPortions extends StatelessWidget {
  final int count;
  final void Function()? onIncrement;
  final void Function()? onDecrement;

  const NumOfPortions({
    this.count = 1,
    required this.onDecrement,
    required this.onIncrement,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 15),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          const Expanded(child: HeadTex(str: 'Number of Portions')),
          CustomButtonDetails(
            str: '-',
            count: count, onPressed: onDecrement,
          ),
          ShowResultDet(
            count: count,
          ),
          CustomButtonDetails(
            str: '+',
            count: count, onPressed: onIncrement,
          ),
        ],
      ),
    );
  }
}
