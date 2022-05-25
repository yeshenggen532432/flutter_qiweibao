import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutterqiweibao/model/route.dart';
import 'package:flutterqiweibao/ui/ware_edit.dart';
import 'dart:ui' as ui;

void main() {
  runApp( MyApp(param: ui.window.defaultRouteName));
//  runApp( MyApp(param: "{\"route\":\"ware_edit\", \"type\":false}"));
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
    print(param);
    RouteBean routeBean = RouteBean.fromJson(json.decode(param.toString()));
    print("路由："+routeBean.route.toString());
    return MaterialApp(
      title: '企微宝',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      initialRoute: routeBean.route,
      routes: {
        "ware_edit": (context)=> WareEdit(type: routeBean.type!, wareId: routeBean.wareId),
//        "ware_edit": (context)=> WareEdit(type: false),
      },
      builder: EasyLoading.init(),
//      home: const WareEdit(),
    );
  }

}
