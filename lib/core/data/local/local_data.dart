import 'package:shared_preferences/shared_preferences.dart';

class SharedPrefUtil {
  late SharedPreferences sharedPreferences;
  initStorage() async{
    sharedPreferences = await SharedPreferences.getInstance();
  }
  static Future<void> setSeenOnboarding(bool value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('seen', value);
  }

  static Future<bool> hasSeenOnboarding() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getBool('seen') ?? false;
  }

  static Future<bool> setIdUser(String email) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.setString('userId', email);
  }



}
