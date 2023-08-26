part of styles;

class ThemeManager {
  static ThemeData get lightTheme {
    return ThemeData( //2
        primaryColor: Colors.transparent,
        scaffoldBackgroundColor: whiteColor,
        fontFamily: 'Metropolis', //3
        buttonTheme: ButtonThemeData( // 4
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18.0)),
          buttonColor: orangeColor,
        ),

//-------------------------------AppBarTheme------------------------------------
        appBarTheme:  AppBarTheme(
            toolbarHeight: AppSize.s100.h,
            elevation: 0,
            iconTheme: const IconThemeData(
              size: AppSize.s25,
              color: primaryFontColor,
            ),
            // titleSpacing: 30,
            actionsIconTheme: const IconThemeData(
              size: AppSize.s25,
              color: primaryFontColor,
            ),
            backgroundColor: Colors.transparent,
            titleTextStyle: TextStyle(fontSize: 24.0.sp,fontFamily: 'Metropolis', fontWeight: FontWeight.w500, color: primaryFontColor)
        ),


//--------------------------------textTheme-------------------------------------
        textTheme:   TextTheme(
          displayLarge: TextStyle(fontSize: 30.sp, fontFamily: 'Metropolis',fontWeight: FontWeight.w600, color: primaryFontColor),
          displayMedium: TextStyle(fontSize: 28.0.sp,fontFamily: 'Metropolis', fontWeight: FontWeight.w600, color: blackColor),
          displaySmall: TextStyle(fontSize: 24.0.sp,fontFamily: 'Metropolis', fontWeight: FontWeight.w600, color: blackColor),
          headlineMedium: TextStyle(fontSize: 22.0.sp,fontFamily: 'Metropolis', fontWeight: FontWeight.bold, color: blackColor),
          headlineSmall: TextStyle(fontSize: 14.0.sp,fontFamily: 'Metropolis', fontWeight: FontWeight.w600, color: primaryFontColor ),
          titleLarge: TextStyle(fontSize: 11.0.sp,fontFamily: 'Metropolis', fontWeight: FontWeight.normal, color: secondaryFontColor),
          titleSmall: TextStyle(fontSize: 14.sp,fontFamily: 'Metropolis', fontWeight: FontWeight.w500, color: primaryFontColor),
          bodyLarge: TextStyle(fontSize: 15.0.sp,fontFamily: 'Metropolis', fontWeight: FontWeight.bold, color: blackColor ),
          // bodyText2: TextStyle(fontSize: 12.0.sp,fontFamily: 'Open Sans', fontWeight: FontWeight.normal, color: blackColor ),
          titleMedium: TextStyle(fontSize: 16.sp,fontFamily: 'Metropolis', fontWeight: FontWeight.bold, color: blackColor),
          bodyMedium: TextStyle(fontSize: AppSize.s15 , fontFamily: 'Metropolis', fontWeight: FontWeight.normal, color: primaryFontColor),
          labelMedium: TextStyle(fontSize: 14.0.sp,fontFamily: 'Metropolis', fontWeight: FontWeight.normal, color: secondaryFontColor ),
          bodySmall: TextStyle(fontSize: 11.0.sp,fontFamily: 'Metropolis', fontWeight: FontWeight.normal, color: primaryFontColor )
        ),

//-------------------------------ElevatedButtonTheme----------------------------
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
              backgroundColor: orangeColor,
              textStyle: TextStyle(fontSize: 16.sp, fontFamily: 'Metropolis', fontWeight: FontWeight.w600, color: whiteColor),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(AppSize.s28.r),
              ),
              minimumSize: Size(double.infinity, 56.h)
          ),
        ),

//------------------------------InputDecorationTheme----------------------------
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: placeholderBg,
          contentPadding: EdgeInsets.symmetric(vertical: AppPadding.p15.h, horizontal: AppPadding.p20.w),
          border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppSize.s28.r),
              borderSide: const BorderSide(
                  color: Colors.transparent
              )
          ),
          enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppSize.s28.r),
              borderSide: const BorderSide(
                color: placeholderBg,
              )
          ),
          errorBorder:  OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(AppSize.s28.r)),
            borderSide:  const BorderSide(
              color: redColor,
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(AppSize.s28.r)),
            borderSide: const BorderSide(
              color: orangeColor,
              width: 2,
            ),
          ),
        )

//------------------------------------------------------------------------------
    );
  }
}