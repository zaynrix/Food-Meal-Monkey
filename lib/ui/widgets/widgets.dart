library widgets;

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:food_delivery_app/core/controllers/home_Controllers/home_controller.dart';
import 'package:food_delivery_app/core/controllers/profile_controllers/profile_controller.dart';
import 'package:food_delivery_app/resources/values_manager.dart';
import 'package:food_delivery_app/utils/extension/time_extension.dart';
import 'package:provider/provider.dart';

import '../../resources/styles.dart';

part 'auth_widgets/footer_auth.dart';
part 'auth_widgets/header_auth.dart';
part 'custom_button.dart';
part 'custom_circle_avatar.dart';
part 'homeWidgets/current_location.dart';
part 'homeWidgets/headar-list.dart';
part 'homeWidgets/most_popular.dart';
part 'homeWidgets/popular_restaurents.dart';
part 'homeWidgets/recent_items.dart';
part 'homeWidgets/search_bar.dart';
part 'item_rating.dart';
part 'menu_widgets//dessert_widget.dart';
part 'more_widgets/inbox_tile.dart';
part 'more_widgets/more_tile.dart';
part 'splash_logo.dart';
part 'text_field.dart';
