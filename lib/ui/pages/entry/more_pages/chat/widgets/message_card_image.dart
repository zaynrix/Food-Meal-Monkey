import 'package:flutter/material.dart';
import 'package:food_delivery_app/ui/pages/entry/more_pages/chat/widgets/error_widget.dart';
import 'package:food_delivery_app/utils/extension/responsive_extension.dart';

void _showEnlargedImage({BuildContext? context, String? imageUrl}) {
  showDialog(
    context: context!,
    builder: (BuildContext context) {
      return Dialog(
        child: GestureDetector(
          onTap: () {
            Navigator.of(context).pop();
          },
          child: Image.network(
            imageUrl!,
            fit: BoxFit.contain,
          ),
        ),
      );
    },
  );
}

Widget chatImage({required String imageSrc, required Function onTap, context}) {
  return OutlinedButton(
    onPressed: () => _showEnlargedImage(context: context, imageUrl: imageSrc),
    child: Image.network(
      imageSrc,
      width: 200.width,
      height: 200.height,
      fit: BoxFit.cover,
      loadingBuilder:
          (BuildContext ctx, Widget child, ImageChunkEvent? loadingProgress) {
        if (loadingProgress == null) return child;
        return Container(
          decoration: BoxDecoration(
            color: Colors.blueGrey,
            borderRadius: BorderRadius.circular(10.borderRadius),
          ),
          width: 200.width,
          height: 200.height,
          child: Center(
            child: CircularProgressIndicator(
              color: Colors.red,
              value: loadingProgress.expectedTotalBytes != null &&
                      loadingProgress.expectedTotalBytes != null
                  ? loadingProgress.cumulativeBytesLoaded /
                      loadingProgress.expectedTotalBytes!
                  : null,
            ),
          ),
        );
      },
      errorBuilder: (context, object, stackTrace) => errorContainer(),
    ),
  );
}
