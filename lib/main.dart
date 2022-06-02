import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutterqiweibao/ui/base/choose_customer.dart';
import 'package:flutterqiweibao/ui/ware_edit.dart';
import 'dart:ui' as ui;

import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

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
    return RefreshConfiguration(
        footerTriggerDistance: 15,
        dragSpeedRatio: 0.91,
        headerBuilder: () => WaterDropHeader(),
        footerBuilder: () => ClassicFooter(),
        child: MaterialApp(
          title: '企微宝',
          theme: ThemeData(
            primarySwatch: Colors.blue,
          ),
//      initialRoute: ui.window.defaultRouteName,
          routes: {
            "ware_edit": (context) => const WareEdit(),
            "choose_customer": (context) => const ChooseCustomer(),
          },
          builder: EasyLoading.init(),
          home: const WareEdit(),
          localizationsDelegates: [
            RefreshLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate
          ],
          supportedLocales: [
            const Locale('en'),
            const Locale('zh'),
          ],
          locale: const Locale('zh'),
//          localeResolutionCallback:
//              (Locale locale, Iterable<Locale> supportedLocales) {
//            //print("change language");
//            return locale;
//          },
        ));

  }
}
