import 'package:flutter/material.dart';
import 'package:flutterqiweibao/utils/color_util.dart';
import 'package:fluttertoast/fluttertoast.dart';

class ToastUtil{
  static void normal(msg){
    Fluttertoast.showToast(
        msg: msg,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        timeInSecForIosWeb: 1,
        backgroundColor: ColorUtil.GRAY_3,
        textColor: Colors.white,
        fontSize: 16.0
    );
  }

  static void error(msg){
    Fluttertoast.showToast(
        msg: msg,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        timeInSecForIosWeb: 1,
        backgroundColor: ColorUtil.RED,
        textColor: Colors.white,
        fontSize: 16.0
    );
  }

  static void success(msg){
    Fluttertoast.showToast(
        msg: msg,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        timeInSecForIosWeb: 1,
        backgroundColor: ColorUtil.green,
        textColor: Colors.white,
        fontSize: 16.0
    );
  }
}