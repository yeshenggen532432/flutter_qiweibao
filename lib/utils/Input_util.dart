import 'package:flutter/services.dart';

class InputUtil{

  static List<TextInputFormatter>? getInputFormatList(TextInputType? inputType){
    List<TextInputFormatter> list = [];
    if(inputType == TextInputType.number){
      list.add(FilteringTextInputFormatter.allow(RegExp("[0-9.]")));
    }
    return null;
  }
}