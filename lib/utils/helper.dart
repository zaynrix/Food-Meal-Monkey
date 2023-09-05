import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:food_delivery_app/resources/styles.dart';
import 'package:food_delivery_app/resources/values_manager.dart';
import 'package:food_delivery_app/routing/navigations.dart';
import 'package:food_delivery_app/ui/widgets/widgets.dart';
import 'package:food_delivery_app/utils/enums.dart';
import 'package:food_delivery_app/utils/extension/responsive_extension.dart';

class Helpers {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  static showLoadingDialog(
      {required String message, required LoadingStatusOption status}) {
    showDialog(
      barrierDismissible: false,
      context: ServiceNavigation.serviceNavi.navKey.currentState!.context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(borderRadius: 16.circularRadius),
          backgroundColor: whiteColor,
          child: Padding(
            padding: AppPadding.p24.paddingAll,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                LoadingStatusWidget(
                  loadingStatus: status,
                ),
                Text(message)
              ],
            ),
          ),
        );
      },
    );
  }

  static showSnackBar({required String message, required bool isSuccess}) {
    print("ssss $message");
    ServiceNavigation.scaffoldKey.currentState?.showSnackBar(SnackBar(
      content: Text(message),
      duration: const Duration(seconds: 1),
      backgroundColor: isSuccess == true ? Colors.blue : Colors.red,
      elevation: 10,
      margin: EdgeInsets.symmetric(horizontal: 30.w, vertical: 40.h),
      shape: const StadiumBorder(),
      behavior: SnackBarBehavior.floating,
    ));
    print("After Snak");
  }


  Color? getStatusColor(String status) {
    final Map<String, Color> statusColors = {
      'Shipped': const Color(0xFFC3E4F2),
      'Completed': const Color(0xFFD3EFC3),
      'Canceled': const Color(0xFFFF9D97),
      'In Processing': const Color(0xFFC3E4F2),
    };

    if (statusColors.containsKey(status)) {
      return statusColors[status];
    }
    // Return a default color if the status is not recognized
    return Colors.transparent;
  }

}

class alertDialog extends StatelessWidget {
  alertDialog(
      {required this.title, required this.content, required this.onPressed});

  final String title;
  final String content;
  final dynamic Function() onPressed;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(title),
      content: Text(content),
      actions: [
        TextButton(onPressed: onPressed, child: const Text("Ok")),
        // TextButton(onPressed: (){}, child: const Text("Cancel")),
      ],
    );
  }
}

