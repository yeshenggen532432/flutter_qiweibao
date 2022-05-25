class QualityUnitUtil{

  static String getText(int value){
    String text = "天";
    if(value == 1){
      text = "天";
    }else if(value == 2){
      text = "月";
    }else if(value == 3){
      text = "年";
    }
    return text;
  }
}