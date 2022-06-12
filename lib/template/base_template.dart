import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutterqiweibao/utils/color_util.dart';
import 'package:flutterqiweibao/utils/font_size_util.dart';


///头部：返回键
// ignore: must_be_immutable
class TitleBackView extends StatelessWidget{
  MethodChannel? methodChannel;
  TitleBackView({Key? key, this.methodChannel}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.arrow_back_ios, size: 15),
      onPressed: () {
        Navigator.pop(context);
        if(null != methodChannel){
          methodChannel?.invokeMethod("closeActivity");
        }
      },
    );
  }
}

///可操作按钮
///默认：蓝色， 高度40
class ButtonEdit extends StatelessWidget{
  String text;
  VoidCallback onClick;
  ButtonEdit(this.text,{Key? key, required this.onClick}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 40,
      margin: EdgeInsets.all(10),
      child: RaisedButton(
        onPressed: () {
          onClick();
        },
        color: ColorUtil.BLUE,
        textColor: ColorUtil.White,
        child: Text(text, style: TextStyle(fontSize: FontSizeUtil.BIG)),
      ),
    );
  }
}

///分隔线
///默认：水平， 高度=1，颜色=灰色
class Line extends StatelessWidget{
  double? height;
  Color? color;
  Line({Key? key, this.height = 1, this.color}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Divider(height: height, color: color ?? ColorUtil.LINE_GRAY);
  }
}
