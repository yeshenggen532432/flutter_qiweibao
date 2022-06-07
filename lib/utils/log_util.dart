import 'dart:developer';

class LogUtil{
  static bool _isDebug = true;
  static void d(dynamic obj) {
    if (_isDebug && obj != null) {
      log("flutter:"+obj.toString());
    }
  }
}