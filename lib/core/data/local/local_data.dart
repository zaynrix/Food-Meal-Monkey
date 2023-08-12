import 'package:shared_preferences/shared_preferences.dart';

class SharedPrefUtil {
  static Future<void> setSeenOnboarding(bool value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('seen', value);
  }

  static Future<bool> hasSeenOnboarding() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getBool('seen') ?? false;
  }
}
