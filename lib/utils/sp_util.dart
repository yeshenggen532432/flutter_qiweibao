import 'package:shared_preferences/shared_preferences.dart';

class SpUtil{

  static Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString("token");
    return token;
  }

}