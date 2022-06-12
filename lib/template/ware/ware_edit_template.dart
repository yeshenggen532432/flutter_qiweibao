import 'package:flutter/material.dart';
import 'package:flutterqiweibao/utils/color_util.dart';
import 'package:flutterqiweibao/utils/font_size_util.dart';
import 'package:flutterqiweibao/utils/string_util.dart';



///左标签+编辑框+按钮；右标签+编辑框+文本；
class WareRowLabelEditThree extends StatelessWidget {
  TextEditingController leftController;
  String leftLabel;
  String? leftHint;
  TextInputType? leftInputType;
  VoidCallback? onLeftClick;
  String leftTwoValue;
  TextEditingController rightController;
  String rightLabel;
  String? rightHint;
  TextInputType? rightInputType;
  WareRowLabelEditThree({
    Key? key,
    required this.leftController,
    required this.leftLabel,
    this.leftHint = "请输入",
    this.leftInputType = TextInputType.text,
    this.onLeftClick,
    this.leftTwoValue = "天",
    required this.rightController,
    required this.rightLabel,
    this.rightHint = "请输入",
    this.rightInputType = TextInputType.text,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          child: Row(
            children: [
              Expanded(
                  child: Row(
                    children: [
                      Text(leftLabel,
                          style: TextStyle(
                              color: ColorUtil.GRAY_6,
                              fontSize: FontSizeUtil.MIDDLE)),
                      Expanded(
                          child: TextField(
                            controller: leftController,
                            keyboardType: leftInputType,
                            decoration: InputDecoration(
                              isCollapsed: true, //重点，相当于⾼度包裹的意思，必须设置为true，不然有默认奇妙的最⼩⾼度
                              contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 8, vertical: 10), //内容内边距，影响⾼度
                              hintText: leftHint,
                              hintStyle: TextStyle(
                                  color: ColorUtil.hint_gray,
                                  fontSize: FontSizeUtil.MIDDLE),
                              border:
                              const OutlineInputBorder(borderSide: BorderSide.none),
                            ),
                          )),
                      TextButton(
                        onPressed: () {
                          onLeftClick!();
                        },
                        child: Text(
                          leftTwoValue + StringUtil.ARROW_DOWN,
                          style: TextStyle(
                              color: ColorUtil.BLUE, fontSize: FontSizeUtil.MIDDLE),
                        ),
                      )
                    ],
                  )),
              Expanded(
                  child: Row(
                    children: [
                      Text(rightLabel,
                          style: TextStyle(
                              color: ColorUtil.GRAY_6,
                              fontSize: FontSizeUtil.MIDDLE)),
                      Expanded(
                          child: TextField(
                            controller: rightController,
                            keyboardType: rightInputType,
                            decoration: InputDecoration(
                              isCollapsed: true, //重点，相当于⾼度包裹的意思，必须设置为true，不然有默认奇妙的最⼩⾼度
                              contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 8, vertical: 10), //内容内边距，影响⾼度
                              hintText: rightHint,
                              hintStyle: TextStyle(
                                  color: ColorUtil.hint_gray,
                                  fontSize: FontSizeUtil.MIDDLE),
                              border:
                              const OutlineInputBorder(borderSide: BorderSide.none),
                            ),
                          )),
                      Text("天",
                          style: TextStyle(
                              color: ColorUtil.GRAY_6,
                              fontSize: FontSizeUtil.MIDDLE))
                    ],
                  ))
            ],
          ),
        ),
        Divider(height: 1, color: ColorUtil.LINE_GRAY),
      ],
    );
  }
}



