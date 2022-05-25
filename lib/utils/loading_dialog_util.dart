
import 'package:flutter_easyloading/flutter_easyloading.dart';

class LoadingDialogUtil{

  static void show(){
    EasyLoading.show(status: "加载中...");
  }
  static void dismiss(){
    EasyLoading.dismiss();
  }
}