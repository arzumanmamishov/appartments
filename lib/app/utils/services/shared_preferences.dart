import 'package:shared_preferences/shared_preferences.dart';

class SPHelper {
  static String sharedPreferenceUserIdKey = "USERIDEKEY";

  static Future<bool> saveTokenSharedPreference(String tokenKey) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return await preferences.setString(sharedPreferenceUserIdKey, tokenKey);
  }

  static Future<String?> getTokenSharedPreference() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return preferences.getString(sharedPreferenceUserIdKey);
  }
}
