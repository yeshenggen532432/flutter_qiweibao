class WareIsTypeUtil{

  static String getText(String isType){
    String text = "库存商品类";
    if(isType == "0"){
      text = "库存商品类";
    }else if(isType == "1"){
      text = "原辅材料类";
    }else if(isType == "2"){
      text = "低值易耗品类";
    }else if(isType == "3"){
      text = "固定资产类";
    }else if(isType == "4"){
      text = "联盟商品类";
    }
    return text;
  }
}