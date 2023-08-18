library pages;

import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_slider_indicator/flutter_slider_indicator.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:food_delivery_app/core/controllers/auth_controller/auth_controller.dart';
import 'package:food_delivery_app/core/controllers/profile_controllers/profile_controller.dart';
import 'package:food_delivery_app/core/model/menu_model.dart';
import 'package:food_delivery_app/core/model/models.dart';
import 'package:food_delivery_app/resources/values_manager.dart';
import 'package:food_delivery_app/routing/navigations.dart';
import 'package:food_delivery_app/routing/router.dart';
import 'package:food_delivery_app/ui/pages/entry/more_pages/chat/chat_controllers/chat_controller.dart';
import 'package:food_delivery_app/ui/pages/entry/more_pages/chat/firestore_constants.dart';
import 'package:food_delivery_app/ui/pages/entry/more_pages/chat/widgets/inbox_tile.dart';
import 'package:food_delivery_app/ui/pages/entry/profile_pages/profile_page.dart';
import 'package:food_delivery_app/utils/app_config.dart';
import 'package:food_delivery_app/utils/extension/responsive_extension.dart';
import 'package:food_delivery_app/utils/extension/validate_extension.dart';
import 'package:provider/provider.dart';

import '../../core/controllers/home_Controllers/home_controller.dart';
import '../../resources/styles.dart';
import '../widgets/conrainer_side.dart';
import '../widgets/homeWidgets/home_category.dart';
import '../widgets/menu_widgets/menu_tile.dart';
import '../widgets/widgets.dart';

part 'entry/auth_pages//login_page.dart';
part 'entry/auth_pages//mobile_otp_page.dart';
part 'entry/auth_pages//new_password_page.dart';
part 'entry/auth_pages//reset_password_screen.dart';
part 'entry/auth_pages/on_boarding_page.dart';
part 'entry/auth_pages/splash_page.dart';
part 'entry/auth_pages/starter_page.dart';
part 'entry/home_pages//home_page.dart';
part 'entry/home_pages//main_page.dart';
part 'entry/home_pages/offers_page.dart';
part 'entry/menu_pages//desserts_page.dart';
part 'entry/menu_pages//menu_page.dart';
part 'entry/more_pages//main_more_page.dart';
part 'entry/more_pages/about_as_page.dart';
part 'entry/more_pages/chat/ui/chat_home_screen.dart';
