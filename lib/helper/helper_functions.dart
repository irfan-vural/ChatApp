import 'package:shared_preferences/shared_preferences.dart';

class HelperFunctions {
  // saving data to shared preferences
  // getting data from shared preferences

  static String UserLoggedInKey = "ISLOGGEDIN";
  static String UserNameKey = "USERNAMEKEY";
  static String UserEmailKey = "USEREMAILKEY";

  static Future<bool?> getUserLoggedInStatus(bool isUserLoggedIn) async {
    SharedPreferences sf = await SharedPreferences.getInstance();
    return await sf.setBool(UserLoggedInKey, isUserLoggedIn);
  }
}
