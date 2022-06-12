import 'package:flutter/material.dart';
import 'package:flutterqiweibao/template/base_template.dart';
import 'package:flutterqiweibao/utils/Input_util.dart';
import 'package:flutterqiweibao/utils/color_util.dart';
import 'package:flutterqiweibao/utils/font_size_util.dart';
import 'package:flutterqiweibao/utils/string_util.dart';

/// 单行按钮
class RowButton extends StatelessWidget {
  String text;
  VoidCallback? onClick;
  bool appendDown;
  RowButton(this.text, {Key? key, this.onClick, this.appendDown = false})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 40,
      alignment: Alignment.center,
      child: TextButton(
          onPressed: () {
            onClick!();
          },
          child: Text(text + (appendDown ? StringUtil.ARROW_DOWN : ""),
              style: TextStyle(
                  color: ColorUtil.BLUE, fontSize: FontSizeUtil.BIG))),
    );
  }
}

///标签+编辑框
class RowLabelEdit extends StatelessWidget {
  TextEditingController controller;
  String label;
  String? hint;
  TextInputType? inputType;
  String? tip;
  RowLabelEdit(
      {Key? key,
      required this.controller,
      required this.label,
      this.hint = "请输入",
      this.inputType = TextInputType.text,
      this.tip = ""})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          child: Row(
            children: [
              Text(
                label,
                style: TextStyle(
                    color: ColorUtil.GRAY_6, fontSize: FontSizeUtil.MIDDLE),
              ),
              Expanded(
                  child: TextField(
                      controller: controller,
                      keyboardType: inputType,
                      inputFormatters: InputUtil.getInputFormatList(inputType),
                      decoration: InputDecoration(
                          isCollapsed:
                              true, //重点，相当于⾼度包裹的意思，必须设置为true，不然有默认奇妙的最⼩⾼度
                          contentPadding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 10), //内容内边距，影响⾼度
                          hintText: hint,
                          hintStyle: TextStyle(
                              color: ColorUtil.hint_gray,
                              fontSize: FontSizeUtil.MIDDLE),
                          border: const OutlineInputBorder(
                              borderSide: BorderSide.none)))),
              Offstage(
                offstage: tip!.isNotEmpty ? false : true,
                child: Text("为空时默认采购价(大)",
                    style: TextStyle(
                        color: ColorUtil.RED, fontSize: FontSizeUtil.TIP_RED)),
              ),
            ],
          ),
        ),
        Line(),
      ],
    );
  }
}

///标签+下拉菜单
class RowLabelMenu extends StatelessWidget {
  String label;
  VoidCallback onClick;
  String menuValue;
  RowLabelMenu({
    Key? key,
    required this.label,
    required this.onClick,
    required this.menuValue,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: 40,
          child: Row(
            children: [
              Text(label,
                  style: TextStyle(
                      color: ColorUtil.GRAY_6, fontSize: FontSizeUtil.MIDDLE)),
              Expanded(
                  child: GestureDetector(
                onTap: () {
                  onClick();
                },
                child: Text(menuValue,
                    style: TextStyle(
                        color: ColorUtil.BLUE, fontSize: FontSizeUtil.MIDDLE)),
              )),
              const Icon(Icons.arrow_drop_down)
            ],
          ),
        ),
        Line(),
      ],
    );
  }
}

///左标签+编辑框；右标签+编辑框；
class RowTwoLabelEdit extends StatelessWidget {
  TextEditingController leftController;
  String leftLabel;
  String? leftHint;
  TextInputType? leftInputType;
  TextEditingController rightController;
  String rightLabel;
  String? rightHint;
  TextInputType? rightInputType;
  RowTwoLabelEdit({
    Key? key,
    required this.leftController,
    required this.leftLabel,
    this.leftHint = "请输入",
    this.leftInputType = TextInputType.text,
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
                    inputFormatters:
                        InputUtil.getInputFormatList(leftInputType),
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
                    inputFormatters:
                        InputUtil.getInputFormatList(rightInputType),
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
                  ))
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

///左标签+按钮；右标签+按钮；
class RowTwoLabelButton extends StatelessWidget {
  VoidCallback? onLeftClick;
  String leftLabel;
  String leftValue;
  VoidCallback? onRightClick;
  String rightLabel;
  String rightValue;
  RowTwoLabelButton({
    Key? key,
    required this.onLeftClick,
    required this.leftLabel,
    this.leftValue = "选择",
    required this.onRightClick,
    required this.rightLabel,
    this.rightValue = "选择",
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
                  //Flexible：解决Text文字太长
                  Flexible(
                      child: TextButton(
                          onPressed: () {
                            onLeftClick!();
                          },
                          child: Text(
                              (leftValue.isNotEmpty ? leftValue : "选择") +
                                  StringUtil.ARROW_DOWN,
                              softWrap: true,
                              style: TextStyle(
                                  color: ColorUtil.BLUE,
                                  fontSize: FontSizeUtil.MIDDLE))))
                ],
              )),
              Expanded(
                  child: Row(
                children: [
                  Text(rightLabel,
                      style: TextStyle(
                          color: ColorUtil.GRAY_6,
                          fontSize: FontSizeUtil.MIDDLE)),
                  Flexible(
                      child: TextButton(
                          onPressed: () {
                            onRightClick!();
                          },
                          child: Text(
                              (rightValue.isNotEmpty ? rightValue : "选择") +
                                  StringUtil.ARROW_DOWN,
                              style: TextStyle(
                                  color: ColorUtil.BLUE,
                                  fontSize: FontSizeUtil.MIDDLE))))
                ],
              )),
            ],
          ),
        ),
        Line(),
      ],
    );
  }
}

///左标签+按钮+编辑框；右标签+按钮+编辑框；
class RowTwoLabelButtonEdit extends StatelessWidget {
  TextEditingController leftController;
  String leftLabel;
  String? leftHint;
  TextInputType? leftInputType;
  VoidCallback onLeftClick;
  String leftButtonValue;
  TextEditingController rightController;
  String rightLabel;
  String? rightHint;
  TextInputType? rightInputType;
  VoidCallback onRightClick;
  String rightButtonValue;
  RowTwoLabelButtonEdit({
    Key? key,
    required this.leftController,
    required this.leftLabel,
    this.leftHint = "请输入",
    this.leftInputType = TextInputType.text,
    required this.onLeftClick,
    required this.leftButtonValue,
    required this.rightController,
    required this.rightLabel,
    this.rightHint = "请输入",
    this.rightInputType = TextInputType.text,
    required this.onRightClick,
    required this.rightButtonValue,
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
                  Container(
                    width: 40,
                    height: 40,
                    alignment: Alignment.center,
                    child: GestureDetector(
                        onTap: () {
                          onLeftClick();
                        },
                        child: Text(
                            leftButtonValue.isNotEmpty
                                ? leftButtonValue + StringUtil.ARROW_DOWN
                                : "选择" + StringUtil.ARROW_DOWN,
                            style: TextStyle(
                                color: ColorUtil.BLUE,
                                fontSize: FontSizeUtil.MIDDLE))),
                  ),
                  Expanded(
                      child: TextField(
                    controller: leftController,
                    keyboardType: leftInputType,
                    inputFormatters:
                        InputUtil.getInputFormatList(leftInputType),
                    decoration: InputDecoration(
                      isCollapsed: true, //重点，相当于⾼度包裹的意思，必须设置为true，不然有默认奇妙的最⼩⾼度
                      contentPadding:
                          const EdgeInsets.symmetric(vertical: 10), //内容内边距，影响⾼度
                      hintText: leftHint,
                      hintStyle: TextStyle(
                          color: ColorUtil.hint_gray,
                          fontSize: FontSizeUtil.MIDDLE),
                      border:
                          const OutlineInputBorder(borderSide: BorderSide.none),
                    ),
                  )),
                ],
              )),
              Expanded(
                  child: Row(
                children: [
                  Text(rightLabel,
                      style: TextStyle(
                          color: ColorUtil.GRAY_6,
                          fontSize: FontSizeUtil.MIDDLE)),
                  Container(
                    width: 40,
                    height: 40,
                    alignment: Alignment.center,
                    child: GestureDetector(
                        onTap: () {
                          onRightClick();
                        },
                        child: Text(
                            rightButtonValue.isNotEmpty
                                ? rightButtonValue + StringUtil.ARROW_DOWN
                                : "选择" + StringUtil.ARROW_DOWN,
                            style: TextStyle(
                                color: ColorUtil.BLUE,
                                fontSize: FontSizeUtil.MIDDLE))),
                  ),
                  Expanded(
                      child: TextField(
                    controller: rightController,
                    keyboardType: rightInputType,
                    inputFormatters:
                        InputUtil.getInputFormatList(rightInputType),
                    decoration: InputDecoration(
                      isCollapsed: true, //重点，相当于⾼度包裹的意思，必须设置为true，不然有默认奇妙的最⼩⾼度
                      contentPadding:
                          const EdgeInsets.symmetric(vertical: 10), //内容内边距，影响⾼度
                      hintText: rightHint,
                      hintStyle: TextStyle(
                          color: ColorUtil.hint_gray,
                          fontSize: FontSizeUtil.MIDDLE),
                      border:
                          const OutlineInputBorder(borderSide: BorderSide.none),
                    ),
                  ))
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

///左标签+编辑框+图标按钮；右标签+编辑框+图标按钮；
class RowTwoLabelEditIcon extends StatelessWidget {
  TextEditingController leftController;
  String leftLabel;
  String? leftHint;
  TextInputType? leftInputType;
  VoidCallback onLeftClick;
  Widget leftIcon;
  TextEditingController rightController;
  String rightLabel;
  String? rightHint;
  TextInputType? rightInputType;
  VoidCallback onRightClick;
  Widget rightIcon;
  RowTwoLabelEditIcon({
    Key? key,
    required this.leftController,
    required this.leftLabel,
    this.leftHint = "请输入",
    this.leftInputType = TextInputType.text,
    required this.onLeftClick,
    required this.leftIcon,
    required this.rightController,
    required this.rightLabel,
    this.rightHint = "请输入",
    this.rightInputType = TextInputType.text,
    required this.onRightClick,
    required this.rightIcon,
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
                    inputFormatters:
                        InputUtil.getInputFormatList(leftInputType),
                    maxLines: 3,
                    minLines: 1,
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
                  SizedBox(
                    width: 25,
                    child: GestureDetector(
                        onTap: () {
                          onLeftClick();
                        },
                        child: leftIcon),
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
                    inputFormatters:
                        InputUtil.getInputFormatList(rightInputType),
                    maxLines: 3,
                    minLines: 1,
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
                  SizedBox(
                    width: 25,
                    child: GestureDetector(
                        onTap: () {
                          onRightClick();
                        },
                        child: rightIcon),
                  )
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

///标签+两Radio
class RowLabelTwoRadio extends StatelessWidget {
  String label;
  String groupValue;
  String leftRadioValue;
  ValueChanged<String?>? onLeftChanged;
  String leftLabel;
  String rightRadioValue;
  ValueChanged<String?>? onRightChanged;
  String rightLabel;

  RowLabelTwoRadio({
    Key? key,
    required this.label,
    required this.groupValue,
    required this.leftRadioValue,
    required this.onLeftChanged,
    required this.leftLabel,
    required this.rightRadioValue,
    required this.onRightChanged,
    required this.rightLabel,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: 40,
          child: Row(
            children: [
              Text(label,
                  style: TextStyle(
                      color: ColorUtil.GRAY_6, fontSize: FontSizeUtil.MIDDLE)),
              Radio(
                  value: leftRadioValue,
                  groupValue: groupValue,
                  onChanged: onLeftChanged),
              Text(leftLabel,
                  style: TextStyle(
                      color: ColorUtil.GRAY_6, fontSize: FontSizeUtil.MIDDLE)),
              Radio(
                  value: rightRadioValue,
                  groupValue: groupValue,
                  onChanged: onRightChanged),
              Text(rightLabel,
                  style: TextStyle(
                      color: ColorUtil.GRAY_6, fontSize: FontSizeUtil.MIDDLE)),
            ],
          ),
        ),
        Line(),
      ],
    );
  }
}

///三部分：1.标签； 2.编辑框+左标签； 3.编辑框+右标签；
class RowLabelTwoEditLabel extends StatelessWidget {
  String label;
  TextEditingController leftController;
  bool? leftEditEnable;
  String leftLabel;
  String? leftHint;
  TextInputType? leftInputType;
  TextEditingController rightController;
  String rightLabel;
  String? rightHint;
  TextInputType? rightInputType;
  RowLabelTwoEditLabel({
    Key? key,
    required this.label,
    required this.leftController,
    required this.leftLabel,
    this.leftHint = "请输入",
    this.leftInputType = TextInputType.text,
    this.leftEditEnable = true,
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
              Text(label,
                  style: TextStyle(
                      color: ColorUtil.GRAY_6, fontSize: FontSizeUtil.MIDDLE)),
              Expanded(
                  child: Row(
                children: [
                  Expanded(
                      child: TextField(
                    controller: leftController,
                    keyboardType: leftInputType,
                    inputFormatters:
                        InputUtil.getInputFormatList(leftInputType),
                    enabled: leftEditEnable,
                    decoration: InputDecoration(
                        isCollapsed:
                            true, //重点，相当于⾼度包裹的意思，必须设置为true，不然有默认奇妙的最⼩⾼度
                        contentPadding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 10), //内容内边距，影响⾼度
                        hintText: "点击输入",
                        hintStyle: TextStyle(
                            color: ColorUtil.GRAY_9,
                            fontSize: FontSizeUtil.MIDDLE),
                        border: const OutlineInputBorder(
                            borderSide: BorderSide.none)),
                  )),
                  Text(leftLabel,
                      style: TextStyle(
                          color: ColorUtil.GRAY_6,
                          fontSize: FontSizeUtil.MIDDLE)),
                ],
              )),
              Expanded(
                  child: Row(
                children: [
                  Expanded(
                      child: TextField(
                    controller: rightController,
                    keyboardType: rightInputType,
                    inputFormatters:
                        InputUtil.getInputFormatList(rightInputType),
                    decoration: InputDecoration(
                        isCollapsed:
                            true, //重点，相当于⾼度包裹的意思，必须设置为true，不然有默认奇妙的最⼩⾼度
                        contentPadding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 10), //内容内边距，影响⾼度
                        hintText: "点击输入",
                        hintStyle: TextStyle(
                            color: ColorUtil.GRAY_9,
                            fontSize: FontSizeUtil.MIDDLE),
                        border: const OutlineInputBorder(
                            borderSide: BorderSide.none)),
                  )),
                  Text(rightLabel,
                      style: TextStyle(
                          color: ColorUtil.GRAY_6,
                          fontSize: FontSizeUtil.MIDDLE)),
                ],
              ))
            ],
          ),
        ),
        Line(),
      ],
    );
  }
}
