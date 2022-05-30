import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutterqiweibao/ui/base/choose_customer.dart';
import 'package:flutterqiweibao/ui/ware_edit.dart';
import 'dart:ui' as ui;

void main() {
  runApp(const MyApp());
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
  const MyApp({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '企微宝',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      initialRoute: ui.window.defaultRouteName,
      routes: {
        "ware_edit": (context)=> const WareEdit(),
        "choose_customer": (context)=> const ChooseCustomer(),
      },
      builder: EasyLoading.init(),
//      home: const WareEdit(),
    );
  }

}
