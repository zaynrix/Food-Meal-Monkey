library pages;

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_slider_indicator/flutter_slider_indicator.dart';
import 'package:food_delivery_app/core/model/menu_model.dart';
import 'package:food_delivery_app/core/model/models.dart';
import 'package:food_delivery_app/resources/values_manager.dart';
import 'package:food_delivery_app/routing/navigations.dart';
import 'package:food_delivery_app/routing/router.dart';
import 'package:food_delivery_app/ui/pages/entry/profile_pages/profile_page.dart';
import 'package:food_delivery_app/utils/app_config.dart';
import 'package:provider/provider.dart';

import '../../resources/styles.dart';
import '../widgets/conrainer_side.dart';
import '../widgets/homeWidgets/home_category.dart';
import '../widgets/menu_widgets/menu_tile.dart';
import '../widgets/widgets.dart';

part 'entry/auth_pages//login_page.dart';
part 'entry/auth_pages//mobile_otp_page.dart';
part 'entry/auth_pages//new_password_page.dart';
part 'entry/auth_pages//reset_password_screen.dart';
part 'entry/home_pages//home_page.dart';
part 'entry/home_pages//main_page.dart';
part 'entry/menu_pages//desserts_page.dart';
part 'entry/menu_pages//menu_page.dart';
part 'entry/more_pages//main_more_page.dart';
part 'entry/more_pages/about_as_page.dart';
part 'entry/more_pages/inbox_page.dart';
part 'entry/offers_page.dart';
part 'entry/on_boarding_page.dart';
part 'entry/splash_page.dart';
part 'entry/starter_page.dart';
