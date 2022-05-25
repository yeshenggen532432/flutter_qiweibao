import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'dart:ui' as ui;
import 'package:flutterqiweibao/ui/ware_edit.dart';

void main() {
  runApp( MyApp(param: ui.window.defaultRouteName,));
  configLoading();
}

void configLoading() {
  EasyLoading.instance
    ..displayDuration = const Duration(milliseconds: 2000)
    ..indicatorType = EasyLoadingIndicatorType.fadingCircle
    ..maskType = EasyLoadingMaskType.black
    ..loadingStyle = EasyLoadingStyle.dark
    ..indicatorSize = 45.0
    ..radius = 10.0
    ..progressColor = Colors.yellow
    ..backgroundColor = Colors.green
    ..indicatorColor = Colors.yellow
    ..textColor = Colors.yellow
    ..maskColor = Colors.blue.withOpacity(0.5)
    ..userInteractions = true
    ..dismissOnTap = false;
}

class MyApp extends StatelessWidget {
  String param;
  MyApp({Key? key, required this.param}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '企微宝',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      initialRoute: "ware_edit",
      routes: {
//        "ware_edit": (context)=> WareEdit(type: true, wareId: 2293),
        "ware_edit": (context)=> WareEdit(type: false),
      },
      builder: EasyLoading.init(),
//      home: const WareEdit(),
    );
  }

}
