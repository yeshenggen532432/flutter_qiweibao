import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutterqiweibao/utils/Input_util.dart';
import 'package:flutterqiweibao/utils/color_util.dart';
import 'package:flutterqiweibao/utils/font_size_util.dart';

///清除图标
class BaseTextField extends StatefulWidget {
  TextEditingController controller;
  String? hint;
  TextInputType? inputType;
  bool? enable;
  bool? hasClear;
  BaseTextField({
    Key? key,
    required this.controller,
    this.hint = "点击输入",
    this.inputType = TextInputType.text,
    this.enable = true,
    this.hasClear = true,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return BaseTextFieldState();
  }
}

class BaseTextFieldState extends State<BaseTextField> {
  FocusNode _focusNode = FocusNode();
  bool hasFocus = false;
  @override
  void initState() {
    super.initState();
    _focusNode.addListener(() {
      setState(() {
        hasFocus = _focusNode.hasFocus;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        child: TextField(
      controller: widget.controller,
      focusNode: _focusNode,
      keyboardType: widget.inputType,
      maxLines: 3,
      minLines: 1,
      enabled: widget.enable,
      inputFormatters: InputUtil.getInputFormatList(widget.inputType),
      onChanged: (value) {
        setState(() {
          widget.controller.text = value;
          widget.controller.selection =
              TextSelection.fromPosition(TextPosition(offset: value.length));
        });
      },
      decoration: InputDecoration(
          isCollapsed: true,
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 5, vertical: 13),
          hintText: widget.hint,
          hintStyle: TextStyle(
              color: ColorUtil.hint_gray, fontSize: FontSizeUtil.MIDDLE),
          border: const OutlineInputBorder(borderSide: BorderSide.none),
//        文本框的尾部图标
          suffixIconConstraints:
              const BoxConstraints.expand(width: 20, height: 40),
          suffixIcon: widget.controller.text.isNotEmpty &&
                  widget.hasClear == true &&
                  hasFocus
              ? IconButton(
                  padding: const EdgeInsets.all(0),
                  onPressed: () {
                    setState(() {
                      widget.controller.clear();
                    });
                  },
                  icon: const Icon(
                    Icons.cancel,
                    color: Colors.grey,
                    size: 20,
                  ))
              : null),
    ));
  }
}
