import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutterqiweibao/model/base_result.dart';
import 'package:flutterqiweibao/model/pic_bean.dart';
import 'package:flutterqiweibao/model/pic_result.dart';
import 'package:flutterqiweibao/model/ware/ware.dart';
import 'package:flutterqiweibao/model/ware/ware_intent%20.dart';
import 'package:flutterqiweibao/model/ware/ware_pic.dart';
import 'package:flutterqiweibao/model/ware/ware_result.dart';
import 'package:flutterqiweibao/tree/dialog/tree_ware_type_dialog.dart';
import 'package:flutterqiweibao/tree/tree.dart';
import 'package:flutterqiweibao/utils/color_util.dart';
import 'package:flutterqiweibao/utils/contains_util.dart';
import 'package:flutterqiweibao/utils/font_size_util.dart';
import 'package:flutterqiweibao/utils/loading_dialog_util.dart';
import 'package:flutterqiweibao/utils/quality_unit_util.dart';
import 'package:flutterqiweibao/utils/string_util.dart';
import 'package:flutterqiweibao/utils/toast_util.dart';
import 'package:flutterqiweibao/utils/url_util.dart';
import 'package:flutterqiweibao/utils/ware_is_type_util.dart';
import 'package:image_picker/image_picker.dart';

class WareEdit extends StatefulWidget {
  const WareEdit({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return WareEditState();
  }
}

class WareEditState extends State<WareEdit> {
  bool add = true;
  int? wareId;
  static MethodChannel _methodChannel = MethodChannel('com.cc.flutter/native');

  @override
  void initState() {
    super.initState();
    _methodChannel.setMethodCallHandler(_methodChannelHandler);
    getWareIntent();
  }

  getWareIntent() async{
    var map = await _methodChannel.invokeMethod("WareIntent");
    print("------------------------getWareIntent-----------------------:"+map.toString());
//    Map<String, dynamic> map = {"add": false, "wareId": 123};
    setState(() {
      WareIntent wareIntent = WareIntent.fromJson(json.decode(map));
      add = wareIntent.add!;
      wareId = wareIntent.wareId;
      if(!add){
        queryDetail();
      }
    });
  }

  /// 原生 调用 Flutter的结果回调
  Future<String> _methodChannelHandler(MethodCall call) async{
    String result = "";
    print("---------------_methodChannelHandler------------------------ method = ${call.method}");
    switch(call.method){
      case "callFlutter":
        setState(() {
          _isTypeText = call.arguments.toString();
        });
        result = "Flutter 收到 Android发来的消息";
        break;
    }
    return result;
  }

  Future<void> queryDetail() async {
      EasyLoading.show(status: "加载中...");
      Map<String, dynamic>? params = {"wareId":wareId};
      var response = await Dio().get(
          UrlUtil.ware_detail,
          queryParameters: params,
          options: Options(headers: {"token": ContainsUtil.token})
      );
      EasyLoading.dismiss();
      logger.d(response);
      WareResult result = WareResult.fromJson(json.decode(response.toString()));
      if(result.state != null && result.state == true){
        doUI(result.sysWare!);
      }
  }

  void doUI(Ware ware){
    setState(() {
      _wareId = ware.wareId;
      _isType = ware.isType!.toString();
      _isTypeText = WareIsTypeUtil.getText(_isType);
      _businessType = ware.businessType != null? ware.businessType.toString(): "0";
      _wareType = ware.waretype != null? ware.waretype.toString(): "0";
      _wareTypeText = ware.waretypeNm!;
      _wareNameController.text = ware.wareNm!;
      _maxUnitController.text = ware.wareDw!;
      _minUnitController.text = ware.minUnit!;
      _maxWareGgUnitController.text = ware.wareGg!;
      _minWareGgUnitController.text = ware.minWareGg!;
      _maxBarCodeController.text = ware.packBarCode!;
      _sUnitController.text = ware.sUnit != null? ware.sUnit.toString(): "";
      _maxLetterSort = ware.sortCode!;
      _maxSortController.text = ware.sort != null? ware.sort.toString(): "";
      _minLetterSort = ware.minSortCode!;
      _minSortController.text = ware.minSort != null? ware.minSort.toString(): "";
      _wareTypeSortController.text = ware.waretypeSort != null? ware.waretypeSort.toString(): "";
      _maxLsPriceController.text = ware.lsPrice != null? ware.lsPrice.toString(): "";
      _minLsPriceController.text = ware.minLsPrice != null? ware.minLsPrice.toString(): "";
      _maxInPriceController.text = ware.inPrice != null? ware.inPrice.toString(): "";
      _minInPriceController.text = ware.minInPrice != null? ware.minInPrice.toString(): "";
      _maxPfPriceController.text = ware.wareDj != null? ware.wareDj.toString(): "";
      _minPfPriceController.text = ware.sunitPrice != null? ware.sunitPrice.toString(): "";
      _innerAccPriceDefaultController.text = ware.innerAccPriceDefault != null? ware.innerAccPriceDefault.toString(): "";
      _lowestSalePriceController.text = ware.lowestSalePrice != null? ware.lowestSalePrice.toString(): "";
      _wareFeaturesController.text = ware.wareFeatures != null? ware.wareFeatures.toString(): "";
      _qualityController.text = ware.qualityDays != null? ware.qualityDays.toString(): "";
      _qualityWarnController.text = ware.qualityAlert != null? ware.qualityAlert.toString(): "";
      _qualityValue =  ware.qualityUnit != null? ware.qualityUnit!: 1;
      _quality = QualityUnitUtil.getText(_qualityValue);
      _warnQtyController.text = ware.warnQty != null? ware.warnQty.toString(): "";
      _picList.addAll(ware.warePicList!);
    });
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          title: Text(add?"新建商品": "修改商品")),
      bottomNavigationBar: Container(
        margin: const EdgeInsets.only(left: 10, right: 10),
        child: RaisedButton(
            onPressed: _save,
            child: const Text("保存"),
            textColor: Colors.white,
            color: Colors.blue),
      ),
      body: Container(
        margin: const EdgeInsets.only(left: 10, right: 10),
        color: Colors.white,
        child: ListView(
          children: [
            SizedBox(
              child: Column(
                children:[
                  Container(
                    alignment: Alignment.center,
                    child: IconButton(onPressed: (){
                      _imagePickerByCamera();
                    }, icon: const Icon(Icons.photo_camera)),
                  ),
                  Offstage(
                    offstage: _picList.isEmpty? true: false,
                    child: GridView.builder(
                        shrinkWrap: true,
                        scrollDirection: Axis.vertical,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: _picList.length,
                        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 5,
                          mainAxisSpacing: 5,
                          crossAxisSpacing: 5,
                        ),
                        itemBuilder: (_, position)=> _picItem(position)
                    ),
                  )
                ]
              ),
            ),
            SizedBox(
              height: 40,
              child: Row(
                children: [
                  Text("商品总类:", style: TextStyle(color: ColorUtil.GRAY_6)),
                  Expanded(
                      child: GestureDetector(
                    onTap: () {
                      _showDialogWareIsType(context);
                    },
                    child: Text(_isTypeText,
                        style: TextStyle(color: ColorUtil.BLUE)),
                  )),
                  const Icon(Icons.arrow_drop_down)
                ],
              ),
            ),
            Divider(height: 1, color: ColorUtil.LINE_GRAY),
            SizedBox(
              height: 40,
              child: Row(
                children: [
                  Text("商品类别属性:", style: TextStyle(color: ColorUtil.GRAY_6)),
                  Radio(
                      value: "0",
                      groupValue: _businessType,
                      onChanged: (value) => !add? null: _changeRadioValue(value)),
                  Text("实物商品",
                      style: TextStyle(
                          color: ColorUtil.GRAY_6,
                          fontSize: FontSizeUtil.MIDDLE)),
                  Radio(
                      value: "1",
                      groupValue: _businessType,
                      onChanged: (value) => !add? null: _changeRadioValue(value)),
                  Text("服务商品",
                      style: TextStyle(
                          color: ColorUtil.GRAY_6,
                          fontSize: FontSizeUtil.MIDDLE)),
                ],
              ),
            ),
            Divider(height: 1, color: ColorUtil.LINE_GRAY),
            SizedBox(
              height: 40,
              child: Row(
                children: [
                  Text("商品类别:", style: TextStyle(color: ColorUtil.GRAY_6)),
                  Expanded(
                      child: GestureDetector(
                    onTap: () {
                      _showDialogWareType(context);
                    },
                    child: Text(_wareTypeText,
                        style: TextStyle(color: ColorUtil.BLUE)),
                  )),
                  const Icon(Icons.arrow_drop_down)
                ],
              ),
            ),
            Divider(
              height: 1,
              color: ColorUtil.LINE_GRAY,
            ),
            Container(
                height: 40,
                alignment: Alignment.center,
                child: TextButton(
                    onPressed: () {},
                    child: Text("商品基础信息" + StringUtil.ARROW_DOWN))),
            SizedBox(
              child: Row(
                children: [
                  Text(
                    "商品名称:",
                    style: TextStyle(
                        color: ColorUtil.GRAY_6, fontSize: FontSizeUtil.MIDDLE),
                  ),
                  Expanded(
                      child: TextField(
                          controller: _wareNameController,
                          decoration: const InputDecoration(
                              hintText: "请输入商品名称",
                              hintStyle: TextStyle(
                                  color: Color(0xFF999999), fontSize: 13),
                              border: OutlineInputBorder(
                                  borderSide: BorderSide.none)))),
                ],
              ),
            ),
            const Divider(height: 1, color: Color(0xffeeeeee)),
            SizedBox(
              child: Row(
                children: [
                  Expanded(
                      child: Row(
                    children: [
                      Text("单位(大):",
                          style: TextStyle(
                              color: ColorUtil.GRAY_6,
                              fontSize: FontSizeUtil.MIDDLE)),
                      Expanded(
                          child: TextField(
                        controller: _maxUnitController,
                        decoration: const InputDecoration(
                          hintText: "如箱",
                          hintStyle:
                              TextStyle(color: Color(0xFF999999), fontSize: 12),
                          border:
                              OutlineInputBorder(borderSide: BorderSide.none),
                        ),
                      )),
                    ],
                  )),
                  Expanded(
                      child: Row(
                    children: [
                      Text("单位(小):",
                          style: TextStyle(
                              color: ColorUtil.GRAY_6,
                              fontSize: FontSizeUtil.MIDDLE)),
                      Expanded(
                          child: TextField(
                        controller: _minUnitController,
                        decoration: const InputDecoration(
                          hintText: "如瓶",
                          hintStyle:
                              TextStyle(color: Color(0xFf999999), fontSize: 12),
                          border:
                              OutlineInputBorder(borderSide: BorderSide.none),
                        ),
                      ))
                    ],
                  ))
                ],
              ),
            ),
            const Divider(height: 1, color: Color(0xffeeeeee)),
            SizedBox(
              child: Row(
                children: [
                  Expanded(
                      child: Row(
                    children: [
                      Text(
                        "规格(大):",
                        style: TextStyle(
                            color: ColorUtil.GRAY_6,
                            fontSize: FontSizeUtil.MIDDLE),
                      ),
                      Expanded(
                          child: TextField(
                        controller: _maxWareGgUnitController,
                        decoration: const InputDecoration(
                            hintText: "如500ml*6",
                            hintStyle: TextStyle(
                                color: Color(0xff999999), fontSize: 13),
                            border: OutlineInputBorder(
                                borderSide: BorderSide.none)),
                      ))
                    ],
                  )),
                  Expanded(
                      child: Row(
                    children: [
                      Text(
                        "规格(小):",
                        style: TextStyle(
                            color: ColorUtil.GRAY_6,
                            fontSize: FontSizeUtil.MIDDLE),
                      ),
                      Expanded(
                          child: TextField(
                        controller: _minWareGgUnitController,
                        decoration: const InputDecoration(
                            hintText: "如500ml",
                            hintStyle: TextStyle(
                                color: Color(0xff999999), fontSize: 13),
                            border: OutlineInputBorder(
                                borderSide: BorderSide.none)),
                      ))
                    ],
                  ))
                ],
              ),
            ),
            const Divider(height: 1, color: Color(0xffeeeeee)),
            SizedBox(
              child: Row(
                children: [
                  Expanded(
                      child: Row(
                    children: [
                      Text(
                        "条码(大):",
                        style: TextStyle(
                            color: ColorUtil.GRAY_6,
                            fontSize: FontSizeUtil.MIDDLE),
                      ),
                      Expanded(
                          child: TextField(
                        controller: _maxBarCodeController,
                        decoration: InputDecoration(
                            hintText: "如(箱码)",
                            hintStyle: TextStyle(
                                color: ColorUtil.GRAY_9,
                                fontSize: FontSizeUtil.MIDDLE),
                            border: const OutlineInputBorder(
                                borderSide: BorderSide.none)),
                      )),
                      IconButton(
                          onPressed: () {}, icon: const Icon(Icons.scanner))
                    ],
                  )),
                  Expanded(
                      child: Row(
                    children: [
                      Text("条码(小):",
                          style: TextStyle(
                              color: ColorUtil.GRAY_6,
                              fontSize: FontSizeUtil.MIDDLE)),
                      Expanded(
                          child: TextField(
                        controller: _minBarCodeController,
                        decoration: InputDecoration(
                            hintText: "如(瓶码)",
                            hintStyle: TextStyle(
                                color: ColorUtil.GRAY_9,
                                fontSize: FontSizeUtil.MIDDLE),
                            border: const OutlineInputBorder(
                                borderSide: BorderSide.none)),
                      )),
                      IconButton(
                          onPressed: () {}, icon: const Icon(Icons.scanner))
                    ],
                  ))
                ],
              ),
            ),
            Divider(height: 1, color: ColorUtil.LINE_GRAY),
            SizedBox(
              child: Row(
                children: [
                  Text("大小单位换算比例:",
                      style: TextStyle(
                          color: ColorUtil.GRAY_6,
                          fontSize: FontSizeUtil.MIDDLE)),
                  Text("1",
                      style: TextStyle(
                          color: ColorUtil.GRAY_3, fontSize: FontSizeUtil.BIG)),
                  Text("*大单位=",
                      style: TextStyle(
                          color: ColorUtil.GRAY_6,
                          fontSize: FontSizeUtil.MIDDLE)),
                  Expanded(
                      child: TextField(
                    controller: _sUnitController,
                    decoration: InputDecoration(
                        hintText: "点击输入",
                        hintStyle: TextStyle(
                            color: ColorUtil.GRAY_9,
                            fontSize: FontSizeUtil.MIDDLE),
                        border: const OutlineInputBorder(
                            borderSide: BorderSide.none)),
                  )),
                  Text("*小单位",
                      style: TextStyle(
                          color: ColorUtil.GRAY_6,
                          fontSize: FontSizeUtil.MIDDLE)),
                ],
              ),
            ),
            Container(
              height: 40,
              alignment: Alignment.center,
              child: TextButton(
                  onPressed: () {},
                  child: Text("商品辅助信息1" + StringUtil.ARROW_DOWN,
                      style: TextStyle(
                          color: ColorUtil.BLUE, fontSize: FontSizeUtil.BIG))),
            ),
            SizedBox(
              child: Row(
                children: [
                  Expanded(
                      child: Row(
                    children: [
                      Text("总排序(大):",
                          style: TextStyle(
                              color: ColorUtil.GRAY_6,
                              fontSize: FontSizeUtil.MIDDLE)),
                      SizedBox(
                        width: 50,
                        child: TextButton(
                            onPressed: () {
                              _showDialogLetter(context, true);
                            },
                            child: Text(
                                _maxLetterSort.isNotEmpty
                                    ? _maxLetterSort + StringUtil.ARROW_DOWN
                                    : "选择" + StringUtil.ARROW_DOWN,
                                style: TextStyle(
                                    color: ColorUtil.BLUE,
                                    fontSize: FontSizeUtil.MIDDLE))),
                      ),
                      Expanded(
                          child: TextField(
                        controller: _maxSortController,
                        decoration: InputDecoration(
                            hintText: "输入",
                            hintStyle: TextStyle(
                                color: ColorUtil.GRAY_9,
                                fontSize: FontSizeUtil.MIDDLE),
                            border: const OutlineInputBorder(
                                borderSide: BorderSide.none)),
                      ))
                    ],
                  )),
                  Expanded(
                      child: Row(
                    children: [
                      Text("总排序(小):",
                          style: TextStyle(
                              color: ColorUtil.GRAY_6,
                              fontSize: FontSizeUtil.MIDDLE)),
                      SizedBox(
                        width: 50,
                        child: TextButton(
                            onPressed: () {
                              _showDialogLetter(context, false);
                            },
                            child: Text(
                                _minLetterSort.isNotEmpty
                                    ? _minLetterSort + StringUtil.ARROW_DOWN
                                    : "选择" + StringUtil.ARROW_DOWN,
                                style: TextStyle(
                                    color: ColorUtil.BLUE,
                                    fontSize: FontSizeUtil.MIDDLE))),
                      ),
                      Expanded(
                          child: TextField(
                        controller: _minSortController,
                        decoration: InputDecoration(
                            hintText: "输入",
                            hintStyle: TextStyle(
                                color: ColorUtil.GRAY_9,
                                fontSize: FontSizeUtil.MIDDLE),
                            border: const OutlineInputBorder(
                                borderSide: BorderSide.none)),
                      ))
                    ],
                  )),
                ],
              ),
            ),
            SizedBox(
              child: Row(
                children: [
                  Expanded(
                      child: Row(
                    children: [
                      Text("分类排序:",
                          style: TextStyle(
                              color: ColorUtil.GRAY_6,
                              fontSize: FontSizeUtil.MIDDLE)),
                      Expanded(
                          child: TextField(
                        controller: _wareTypeSortController,
                        decoration: InputDecoration(
                            hintText: "点击输入",
                            hintStyle: TextStyle(
                                color: ColorUtil.GRAY_9,
                                fontSize: FontSizeUtil.MIDDLE),
                            border: const OutlineInputBorder(
                                borderSide: BorderSide.none)),
                      ))
                    ],
                  ))
                ],
              ),
            ),
            Divider(height: 1, color: ColorUtil.LINE_GRAY),
            SizedBox(
              child: Row(
                children: [
                  Expanded(
                      child: Row(
                    children: [
                      Text("原价(大):",
                          style: TextStyle(
                              color: ColorUtil.GRAY_6,
                              fontSize: FontSizeUtil.MIDDLE)),
                      Expanded(
                          child: TextField(
                        controller: _maxLsPriceController,
                        decoration: InputDecoration(
                            hintText: "点击输入",
                            hintStyle: TextStyle(
                                color: ColorUtil.GRAY_9,
                                fontSize: FontSizeUtil.MIDDLE),
                            border: const OutlineInputBorder(
                                borderSide: BorderSide.none)),
                      ))
                    ],
                  )),
                  Expanded(
                      child: Row(
                    children: [
                      Text("原价(小):",
                          style: TextStyle(
                              color: ColorUtil.GRAY_6,
                              fontSize: FontSizeUtil.MIDDLE)),
                      Expanded(
                          child: TextField(
                        controller: _minLsPriceController,
                        decoration: InputDecoration(
                            hintText: "点击输入",
                            hintStyle: TextStyle(
                                color: ColorUtil.GRAY_9,
                                fontSize: FontSizeUtil.MIDDLE),
                            border: const OutlineInputBorder(
                                borderSide: BorderSide.none)),
                      ))
                    ],
                  ))
                ],
              ),
            ),
            Divider(height: 1, color: ColorUtil.LINE_GRAY),
            SizedBox(
              child: Row(
                children: [
                  Expanded(
                      child: Row(
                    children: [
                      Text("采购价(大):",
                          style: TextStyle(
                              color: ColorUtil.GRAY_6,
                              fontSize: FontSizeUtil.MIDDLE)),
                      Expanded(
                          child: TextField(
                        controller: _maxInPriceController,
                        decoration: InputDecoration(
                            hintText: "点击输入",
                            hintStyle: TextStyle(
                                color: ColorUtil.GRAY_9,
                                fontSize: FontSizeUtil.MIDDLE),
                            border: const OutlineInputBorder(
                                borderSide: BorderSide.none)),
                      ))
                    ],
                  )),
                  Expanded(
                      child: Row(
                    children: [
                      Text("采购价(小):",
                          style: TextStyle(
                              color: ColorUtil.GRAY_6,
                              fontSize: FontSizeUtil.MIDDLE)),
                      Expanded(
                          child: TextField(
                        controller: _minInPriceController,
                        decoration: InputDecoration(
                            hintText: "点击输入",
                            hintStyle: TextStyle(
                                color: ColorUtil.GRAY_9,
                                fontSize: FontSizeUtil.MIDDLE),
                            border: const OutlineInputBorder(
                                borderSide: BorderSide.none)),
                      ))
                    ],
                  ))
                ],
              ),
            ),
            Divider(height: 1, color: ColorUtil.LINE_GRAY),
            SizedBox(
              child: Row(
                children: [
                  Expanded(
                      child: Row(
                    children: [
                      Text("批发价(大):",
                          style: TextStyle(
                              color: ColorUtil.GRAY_6,
                              fontSize: FontSizeUtil.MIDDLE)),
                      Expanded(
                          child: TextField(
                        controller: _maxPfPriceController,
                        decoration: InputDecoration(
                            hintText: "点击输入",
                            hintStyle: TextStyle(
                                color: ColorUtil.GRAY_9,
                                fontSize: FontSizeUtil.MIDDLE),
                            border: const OutlineInputBorder(
                                borderSide: BorderSide.none)),
                      ))
                    ],
                  )),
                  Expanded(
                      child: Row(
                    children: [
                      Text("批发价(小):",
                          style: TextStyle(
                              color: ColorUtil.GRAY_6,
                              fontSize: FontSizeUtil.MIDDLE)),
                      Expanded(
                          child: TextField(
                        controller: _minPfPriceController,
                        decoration: InputDecoration(
                            hintText: "点击输入",
                            hintStyle: TextStyle(
                                color: ColorUtil.GRAY_9,
                                fontSize: FontSizeUtil.MIDDLE),
                            border: const OutlineInputBorder(
                                borderSide: BorderSide.none)),
                      ))
                    ],
                  ))
                ],
              ),
            ),
            Divider(height: 1, color: ColorUtil.LINE_GRAY),
            SizedBox(
              child: Row(
                children: [
                  Expanded(
                      child: Row(
                    children: [
                      Text("内部核算价(默认):",
                          style: TextStyle(
                              color: ColorUtil.GRAY_6,
                              fontSize: FontSizeUtil.MIDDLE)),
                      Expanded(
                          child: TextField(
                        controller: _innerAccPriceDefaultController,
                        decoration: InputDecoration(
                            hintText: "点击输入",
                            hintStyle: TextStyle(
                                color: ColorUtil.GRAY_9,
                                fontSize: FontSizeUtil.MIDDLE),
                            border: const OutlineInputBorder(
                                borderSide: BorderSide.none)),
                      )),
                      Text("为空时默认采购价(大)",
                          style: TextStyle(
                              color: ColorUtil.RED,
                              fontSize: FontSizeUtil.TIP_RED))
                    ],
                  ))
                ],
              ),
            ),
            Divider(height: 1, color: ColorUtil.LINE_GRAY),
            SizedBox(
              child: Row(
                children: [
                  Expanded(
                      child: Row(
                    children: [
                      Text("最低销售价(大):",
                          style: TextStyle(
                              color: ColorUtil.GRAY_6,
                              fontSize: FontSizeUtil.MIDDLE)),
                      Expanded(
                          child: TextField(
                        controller: _lowestSalePriceController,
                        decoration: InputDecoration(
                            hintText: "点击输入",
                            hintStyle: TextStyle(
                                color: ColorUtil.GRAY_9,
                                fontSize: FontSizeUtil.MIDDLE),
                            border: const OutlineInputBorder(
                                borderSide: BorderSide.none)),
                      ))
                    ],
                  ))
                ],
              ),
            ),
            Divider(height: 1, color: ColorUtil.LINE_GRAY),
            SizedBox(
              child: Row(
                children: [
                  Expanded(
                      child: Row(
                    children: [
                      Text("商品特征:",
                          style: TextStyle(
                              color: ColorUtil.GRAY_6,
                              fontSize: FontSizeUtil.MIDDLE)),
                      Expanded(
                          child: TextField(
                        controller: _wareFeaturesController,
                        decoration: InputDecoration(
                            hintText: "如：红色，白色，蓝色；(每组特征最多4个字)",
                            hintStyle: TextStyle(
                                color: ColorUtil.GRAY_9,
                                fontSize: FontSizeUtil.MIDDLE),
                            border: const OutlineInputBorder(
                                borderSide: BorderSide.none)),
                      ))
                    ],
                  ))
                ],
              ),
            ),
            Divider(height: 1, color: ColorUtil.LINE_GRAY),
            Container(
              height: 40,
              alignment: Alignment.center,
              child: TextButton(
                  onPressed: () {},
                  child: Text("商品辅助信息2" + StringUtil.ARROW_DOWN,
                      style: TextStyle(
                          color: ColorUtil.BLUE, fontSize: FontSizeUtil.BIG))),
            ),
            SizedBox(
              child: Row(
                children: [
                  Expanded(
                      child: Row(
                    children: [
                      Text("保质期:",
                          style: TextStyle(
                              color: ColorUtil.GRAY_6,
                              fontSize: FontSizeUtil.MIDDLE)),
                      Expanded(
                          child: TextField(
                        controller: _qualityController,
                        decoration: InputDecoration(
                            hintText: "点击输入",
                            hintStyle: TextStyle(
                                color: ColorUtil.GRAY_9,
                                fontSize: FontSizeUtil.MIDDLE),
                            border: const OutlineInputBorder(
                                borderSide: BorderSide.none)),
                      )),
                      TextButton(
                        onPressed: () {
                          _showDialogQuality(context);
                        },
                        child: Text(
                          _quality + StringUtil.ARROW_DOWN,
                          style: TextStyle(
                              color: ColorUtil.BLUE,
                              fontSize: FontSizeUtil.MIDDLE),
                        ),
                      )
                    ],
                  )),
                  Expanded(
                      child: Row(
                    children: [
                      Text("保质期预警:",
                          style: TextStyle(
                              color: ColorUtil.GRAY_6,
                              fontSize: FontSizeUtil.MIDDLE)),
                      Expanded(
                          child: TextField(
                        controller: _qualityWarnController,
                        decoration: InputDecoration(
                            hintText: "点击输入",
                            hintStyle: TextStyle(
                                color: ColorUtil.GRAY_9,
                                fontSize: FontSizeUtil.MIDDLE),
                            border: const OutlineInputBorder(
                                borderSide: BorderSide.none)),
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
            SizedBox(
              child: Row(
                children: [
                  Expanded(
                      child: Row(
                    children: [
                      Text("供应商:",
                          style: TextStyle(
                              color: ColorUtil.GRAY_6,
                              fontSize: FontSizeUtil.MIDDLE)),
                      TextButton(
                          onPressed: () {},
                          child: Text("选择" + StringUtil.ARROW_DOWN,
                              style: TextStyle(
                                  color: ColorUtil.BLUE,
                                  fontSize: FontSizeUtil.MIDDLE)))
                    ],
                  )),
                  Expanded(
                      child: Row(
                    children: [
                      Text("商品品牌:",
                          style: TextStyle(
                              color: ColorUtil.GRAY_6,
                              fontSize: FontSizeUtil.MIDDLE)),
                      TextButton(
                          onPressed: () {},
                          child: Text("选择" + StringUtil.ARROW_DOWN,
                              style: TextStyle(
                                  color: ColorUtil.BLUE,
                                  fontSize: FontSizeUtil.MIDDLE)))
                    ],
                  )),
                ],
              ),
            ),
            Divider(height: 1, color: ColorUtil.LINE_GRAY),
            SizedBox(
              child: Row(
                children: [
                  Expanded(
                      child: Row(
                    children: [
                      Text("预警最低数量:",
                          style: TextStyle(
                              color: ColorUtil.GRAY_6,
                              fontSize: FontSizeUtil.MIDDLE)),
                      Expanded(
                          child: TextField(
                        controller: _warnQtyController,
                        decoration: InputDecoration(
                            hintText: "点击输入",
                            hintStyle: TextStyle(
                                color: ColorUtil.GRAY_9,
                                fontSize: FontSizeUtil.MIDDLE),
                            border: const OutlineInputBorder(
                                borderSide: BorderSide.none)),
                      ))
                    ],
                  ))
                ],
              ),
            ),
            Divider(height: 1, color: ColorUtil.LINE_GRAY),
            Container(
              height: 40,
              alignment: Alignment.center,
              child: TextButton(
                  onPressed: () {},
                  child: Text("查看客户类型价" + StringUtil.ARROW_DOWN,
                      style: TextStyle(
                          color: ColorUtil.BLUE, fontSize: FontSizeUtil.BIG))),
            ),
          ],
        ),
      ),
    );
  }

  String _businessType = "0";
  String _isType = "0";
  String _isTypeText = "库存商品类";
  String _wareType = "";
  String _wareTypeText = "未分类";
  String _maxLetterSort = "";
  String _minLetterSort = "";
  String _quality = "天";
  int _qualityValue = 1;
  int? _wareId;
  final TextEditingController _wareNameController = TextEditingController();
  final TextEditingController _maxUnitController = TextEditingController();
  final TextEditingController _minUnitController = TextEditingController();
  final TextEditingController _maxWareGgUnitController = TextEditingController();
  final TextEditingController _minWareGgUnitController = TextEditingController();
  final TextEditingController _maxBarCodeController = TextEditingController();
  final TextEditingController _minBarCodeController = TextEditingController();
  final TextEditingController _sUnitController = TextEditingController();
  final TextEditingController _maxSortController = TextEditingController();
  final TextEditingController _minSortController = TextEditingController();
  final TextEditingController _wareTypeSortController = TextEditingController();
  final TextEditingController _maxLsPriceController = TextEditingController();
  final TextEditingController _minLsPriceController = TextEditingController();
  final TextEditingController _maxInPriceController = TextEditingController();
  final TextEditingController _minInPriceController = TextEditingController();
  final TextEditingController _maxPfPriceController = TextEditingController();
  final TextEditingController _minPfPriceController = TextEditingController();
  final TextEditingController _innerAccPriceDefaultController = TextEditingController();
  final TextEditingController _lowestSalePriceController = TextEditingController();
  final TextEditingController _wareFeaturesController = TextEditingController();
  final TextEditingController _qualityController = TextEditingController();
  final TextEditingController _qualityWarnController = TextEditingController();
  final TextEditingController _warnQtyController = TextEditingController();

  void _showDialogWareIsType(BuildContext context) {
    showDialog(
        context: context,
        builder: (_) => SimpleDialog(
              title: Text("选择商品总类",
                  style: TextStyle(
                      color: ColorUtil.BLUE, fontSize: FontSizeUtil.BIG)),
              children: [
                SimpleDialogOption(
                  child: const Text("库存商品类"),
                  onPressed: () {
                    _changeWareIsType("0", "库存商品类");
                  },
                ),
                SimpleDialogOption(
                  child: const Text("原辅材料类"),
                  onPressed: () {
                    _changeWareIsType("1", "原辅材料类");
                  },
                ),
                SimpleDialogOption(
                  child: const Text("低值易耗品类"),
                  onPressed: () {
                    _changeWareIsType("2", "低值易耗品类");
                  },
                ),
                SimpleDialogOption(
                  child: const Text("固定资产类"),
                  onPressed: () {
                    _changeWareIsType("3", "固定资产类");
                  },
                ),
                SimpleDialogOption(
                  child: const Text("联盟商品类"),
                  onPressed: () {
                    _changeWareIsType("4", "联盟商品类");
                  },
                ),
              ],
            ));
  }

  void _changeWareIsType(value, text) {
    Navigator.pop(context);
    setState(() {
      _isType = value;
      _isTypeText = text;
      _wareType = "";
      _wareTypeText = "";
    });
  }

  List<Map<String, dynamic>> _checkList = [];
  _showDialogWareType(BuildContext context) {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return TreeWareTypeDialog(
              isType: _isType,
              businessType: _businessType,
              checkData: _checkList,
              okCallBack: (value) {
                _checkList = value;
                if (_checkList.isNotEmpty) {
                  setState(() {
                    _wareType = _checkList[0]["waretypeId"].toString();
                    _wareTypeText = _checkList[0]["waretypeNm"];
                  });
                }
              });
        });
  }

  void _showDialogLetter(BuildContext context, bool isMax) {
    showDialog(
        context: context,
        builder: (_) => SimpleDialog(
              title: Text("选择排序编码",
                  style: TextStyle(
                      color: ColorUtil.BLUE, fontSize: FontSizeUtil.BIG)),
              children: getLetterList(isMax),
            ));
  }

  List<Widget> getLetterList(bool isMax) {
    List<Widget> list = [];
    List<String> letterList = [
      "A",
      "B",
      "C",
      "D",
      "E",
      "F",
      "G",
      "H",
      "L",
      "K",
      "M",
      "N",
      "O",
      "P",
      "Q",
      "R",
      "S",
      "T",
      "U",
      "V",
      "W",
      "X",
      "Y",
      "Z",
    ];
    letterList.forEach((item) {
      list.add(SimpleDialogOption(
        child: Text(item),
        onPressed: () {
          _changeLetter(item, isMax);
        },
      ));
    });
    return list;
  }

  void _changeLetter(value, isMax) {
    Navigator.pop(context);
    setState(() {
      if (isMax) {
        _maxLetterSort = value;
        if (_minLetterSort.isEmpty) {
          _minLetterSort = value;
        }
      } else {
        _minLetterSort = value;
        if (_maxLetterSort.isEmpty) {
          _maxLetterSort = value;
        }
      }
    });
  }

  void _changeRadioValue(value) {
    setState(() {
      _businessType = value;
    });
  }

  void _showDialogQuality(BuildContext context) {
    showDialog(
        context: context,
        builder: (_) => SimpleDialog(
              title: Text("保质期",
                  style: TextStyle(
                      color: ColorUtil.BLUE, fontSize: FontSizeUtil.BIG)),
              children: [
                SimpleDialogOption(
                  child: const Text("年"),
                  onPressed: () {
                    _changeQuality("年", 3);
                  },
                ),
                SimpleDialogOption(
                  child: const Text("月"),
                  onPressed: () {
                    _changeQuality("月", 2);
                  },
                ),
                SimpleDialogOption(
                  child: const Text("天"),
                  onPressed: () {
                    _changeQuality("天", 1);
                  },
                ),
              ],
            ));
  }

  void _changeQuality(text, value) {
    Navigator.pop(context);
    setState(() {
      _quality = text;
      _qualityValue = value;
    });
  }

  void _imagePickerByCamera() async {
    ImagePicker _picker = ImagePicker();
    final XFile? photo = await _picker.pickImage(source: ImageSource.camera);
    uploadPic(photo!.path);
  }

  List<WarePic> _picList = [];
  Widget _picItem(int position){
    WarePic pic = _picList[position];
//    File file = File(pic);
    return Stack(
      children:[
        Positioned.fill(child: GestureDetector(
          onTap: (){
          },
          child: RepaintBoundary(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(8.0),
              child: Image.network(UrlUtil.ROOT_UPLOAD + pic.picMini!, fit:BoxFit.cover),
            ),
          ),
        )),
        Positioned(
          right: 0,
          child: GestureDetector(
            onTap: (){
              delPic(pic.pic!, position);
            },
            child: Container(
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20)
              ),
              width: 20,
              height: 20,
              child: Icon(Icons.close, color: ColorUtil.GRAY_9, size: 18,),
            ),
          ),
        )
      ]
    );
  }

  Future<void> uploadPic(String filePath) async {
    EasyLoading.show(status: '加载中...');
    var dio = Dio();
    Map<String, dynamic> map = {};
    map["path"] = "ware";
    map["file"] = await MultipartFile.fromFile(filePath);
    var data = FormData.fromMap(map);
    var response = await dio.post(UrlUtil.upload_pic_single, data: data, options: Options(headers: {"token": ContainsUtil.token}));
    logger.d(response);
    PicResult picResult = PicResult.fromJson(json.decode(response.toString()));
    setState(() {
      EasyLoading.dismiss();
      PicBean picBean = picResult.data;
      _picList.add(WarePic.fromUploadPic(picBean));
    });
  }

  Future<void> delPic(String filePath, int index) async {
    EasyLoading.show(status: '加载中...');
    var dio = Dio();
    Map<String, dynamic> map = {};
    map["object"] = filePath;
    var data = FormData.fromMap(map);
    var response = await dio.post(UrlUtil.del_pic_single, data: data, options: Options(headers: {"token": ContainsUtil.token}));
    logger.d(response);
    BaseResult result = BaseResult.fromJson(json.decode(response.toString()));
    setState(() {
      if(result.state != null && result.state == true){
        EasyLoading.dismiss();
        ToastUtil.success("删除成功");
        _picList.removeAt(index);
      }
    });
  }

  Future<void> _save() async {
    String wareName = _wareNameController.text;
    String maxUnit = _maxUnitController.text;
    String minUnit = _minUnitController.text;
    String maxWareGg = _maxWareGgUnitController.text;
    String minWareGg = _minWareGgUnitController.text;
    String maxBarCode = _maxBarCodeController.text;
    String minBarCode = _minBarCodeController.text;
    String sUnit = _sUnitController.text;
    String maxSort = _maxSortController.text;
    String minSort = _minSortController.text;
    String wareTypeSort = _wareTypeSortController.text;
    String maxLsPrice = _maxLsPriceController.text;
    String minLsPrice = _minLsPriceController.text;
    String maxInPrice = _maxInPriceController.text;
    String minInPrice = _minInPriceController.text;
    String maxPfPrice = _maxPfPriceController.text;
    String minPfPrice = _minPfPriceController.text;
    String innerAccPriceDefault = _innerAccPriceDefaultController.text;
    String lowestSalePrice = _lowestSalePriceController.text;
    String wareFeatures = _wareFeaturesController.text;
    String quality = _qualityController.text;
    String qualityWarn = _qualityWarnController.text;
    String warnQty = _warnQtyController.text;

    var data = {
      "wareId": _wareId,
      "barCodeTip": true,
      "businessType": _businessType,
      "waretype": _wareType,
      "wareNm": wareName,
      "wareDw": maxUnit,
      "minUnit": minUnit,
      "wareGg": maxWareGg,
      "minWareGg": minWareGg,
      "packBarCode": maxBarCode,
      "beBarCode": minBarCode,
      "bUnit": "1",
      "sUnit": sUnit,
      "sortCode": _maxLetterSort,
      "sort": maxSort,
      "minSortCode": _minLetterSort,
      "minSort": minSort,
      "waretypeSort": wareTypeSort,
      "lsPrice": maxLsPrice,
      "minLsPrice": minLsPrice,
      "inPrice": maxInPrice,
      "minInPrice": minInPrice,
      "wareDj": maxPfPrice,
      "sunitPrice": minPfPrice,
      "innerAccPriceDefault": innerAccPriceDefault,
      "lowestSalePrice": lowestSalePrice,
      "wareFeatures": wareFeatures,
      "qualityDays": quality,
      "qualityUnit": _qualityValue,
      "qualityAlert": qualityWarn,
      "warnQty": warnQty,
      "warePicList": _picList,
//  "brandId":,
//    "supId": 1032,
//    "supName": "上海梅林泰康食品有限公司制造",
//    "supType": 0,
    };

    LoadingDialogUtil.show();
    var response = await Dio().post(
        UrlUtil.WARE_SAVE,
        data: data,
        options: Options( headers: {"token": ContainsUtil.token} )
        );
    LoadingDialogUtil.dismiss();
    logger.d(response);
    BaseResult result = BaseResult.fromJson(json.decode(response.toString()));
    if(result.state!){
      ToastUtil.success("保存成功");
      _methodChannel.invokeMethod("closeActivity");
    }else{
      ToastUtil.error(result.msg);
    }
  }


}
