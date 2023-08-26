import 'package:flutter/cupertino.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

addVerticalSpace(double height) {
  return SizedBox(
    height: height,
  );
}

addHorizontalSpace(double width) {
  return SizedBox(
    width: width,
  );
}

class AppMargin {
  static const double m8 = 8.0;
  static const double m12 = 12.0;
  static const double m14 = 14.0;
  static const double m16 = 16.0;
  static const double m18 = 18.0;
  static const double m20 = 20.0;
  static const double m24 = 24.0;
  static const double m30 = 30.0;
  static const double m50 = 50.0;
}

class AppPadding {
  static const double p8 = 8.0;
  static const double p12 = 12.0;
  static const double p14 = 14.0;
  static const double p16 = 16.0;
  static const double p17 = 17.0;
  static const double p15 = 15.0;
  static const double p18 = 18.0;
  static const double p20 = 20.0;
  static const double p24 = 24.0;
  static const double p25 = 25.0;
  static const double p32 = 32.0;
  static const double p34 = 34.0;
  static const double p44 = 44.0;
  static const double p48 = 48.0;
  static const double p104 = 104.0;
  static const double p69 = 69.0;
  static const double p60 = 60.0;
  static const double p70 = 70;
}

class AppSize {
  static const double s1_5 = 1.5;
  static const double s4 = 4.0;
  static const double s5 = 5.0;
  static const double s7 = 7.0;
  static const double s8 = 8.0;
  static const double s10 = 10.0;
  static const double s12 = 12.0;
  static const double s14 = 14.0;
  static const double s15 = 15.0;
  static const double s16 = 16.0;
  static const double s18 = 18.0;
  static const double s20 = 20.0;
  static const double s22 = 22.0;
  static const double s24 = 24.0;
  static const double s25 = 25.0;
  static const double s28 = 28.0;
  static const double s30 = 30.0;
  static const double s32 = 32.0;
  static const double s33 = 33.0;
  static const double s35 = 35.0;
  static const double s38 = 38.0;
  static const double s40 = 40.0;
  static const double s45 = 45.0;
  static const double s50 = 50.0;
  static const double s55 = 55.0;
  static const double s57 = 57.0;
  static const double s60 = 60.0;
  static const double s66 = 66.0;
  static const double s70 = 70.0;
  static const double s74 = 74.0;
  static const double s77 = 77.0;
  static const double s90 = 90.0;
  static const double s80 = 80.0;
  static const double s85 = 85.0;
  static const double s87 = 87.0;
  static const double s100 = 100.0;
  static const double s110 = 110.0;
  static const double s125  = 125.0;
  static const double s130 = 130.0;
  static const double s150 = 150.0;
  static const double s155 = 155.0;
  static const double s180 = 180.0;
  static const double s200 = 200.0;
  static const double s280 = 280.0;
}

final vSpace5 = SizedBox(height: AppSize.s5.h,);
final vSpace20 = SizedBox(height: AppSize.s20.h,);
final vSpace10 = SizedBox(height: AppSize.s10.h,);
final vSpace15 = SizedBox(height: AppSize.s15.h,);
final hSpace14 = SizedBox(width: AppSize.s14.w,);
final hSpace20 = SizedBox(width: AppSize.s20.w,);
final hSpace5 = SizedBox(width: AppSize.s5.w,);
