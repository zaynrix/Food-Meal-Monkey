library pages;

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_slider_indicator/flutter_slider_indicator.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:food_delivery_app/core/controllers/auth_controller/auth_controller.dart';
import 'package:food_delivery_app/core/controllers/cart_controller/cart_controller.dart';
import 'package:food_delivery_app/core/controllers/location_controller/location_controller.dart';
import 'package:food_delivery_app/core/controllers/order_controller/order_controller.dart';
import 'package:food_delivery_app/core/controllers/payment_controller/payment_controller.dart';
import 'package:food_delivery_app/core/controllers/profile_controllers/profile_controller.dart';
import 'package:food_delivery_app/core/model/menu_model.dart';
import 'package:food_delivery_app/core/model/models.dart';
import 'package:food_delivery_app/core/model/order_model.dart';
import 'package:food_delivery_app/core/model/resturant_model.dart';
import 'package:food_delivery_app/resources/strings_manager.dart';
import 'package:food_delivery_app/resources/values_manager.dart';
import 'package:food_delivery_app/routing/navigations.dart';
import 'package:food_delivery_app/routing/router.dart';
import 'package:food_delivery_app/service_locator.dart';
import 'package:food_delivery_app/ui/pages/entry/more_pages/chat/chat_controllers/chat_controller.dart';
import 'package:food_delivery_app/ui/pages/entry/more_pages/chat/firestore_constants.dart';
import 'package:food_delivery_app/ui/pages/entry/more_pages/chat/models/chat_message_model.dart';
import 'package:food_delivery_app/ui/pages/entry/more_pages/chat/models/chat_user.dart';
import 'package:food_delivery_app/ui/pages/entry/more_pages/chat/ui/chat_screen.dart';
import 'package:food_delivery_app/utils/app_config.dart';
import 'package:food_delivery_app/utils/card/card_utilis.dart';
import 'package:food_delivery_app/utils/card/input_formatters.dart';
import 'package:food_delivery_app/utils/enums.dart';
import 'package:food_delivery_app/utils/extension/responsive_extension.dart';
import 'package:food_delivery_app/utils/extension/string_extensions.dart';
import 'package:food_delivery_app/utils/extension/validate_extension.dart';
import 'package:food_delivery_app/utils/helper.dart';
import 'package:food_delivery_app/utils/keyboard_utils.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:grouped_list/grouped_list.dart';
import 'package:provider/provider.dart';

import '../../core/controllers/home_Controllers/home_controller.dart';
import '../../core/model/payment_card.dart';
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
part 'entry/cart_page/cart_page.dart';
part 'entry/cart_page/checkout_page.dart';
part 'entry/home_pages//home_page.dart';
part 'entry/home_pages//main_page.dart';
part 'entry/home_pages/all_recent_item_page.dart';
part 'entry/home_pages/most_popular_page.dart';
part 'entry/home_pages/offers_page.dart';
part 'entry/home_pages/popular_resturant_screen.dart';
part 'entry/menu_pages//desserts_page.dart';
part 'entry/menu_pages//menu_page.dart';
part 'entry/more_pages//main_more_page.dart';
part 'entry/more_pages/about_as_page.dart';
part 'entry/more_pages/chat/ui/chat_home_screen.dart';
part 'entry/more_pages/chat/widgets/chat_item_widget.dart';
part 'entry/more_pages/order_details.dart';
part 'entry/more_pages/orders_page.dart';
part 'entry/payment_pages/add_payment_page.dart';
part 'entry/payment_pages/payment_details.dart';
part 'entry/location_pages/change_location_page.dart';
part 'entry/cart_page/success_order_paeg.dart';
