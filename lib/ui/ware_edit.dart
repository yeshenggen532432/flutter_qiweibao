import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutterqiweibao/model/base/brand_bean.dart';
import 'package:flutterqiweibao/model/base/brand_list_result.dart';
import 'package:flutterqiweibao/model/base/menu_bean.dart';
import 'package:flutterqiweibao/model/base/menu_result.dart';
import 'package:flutterqiweibao/model/base_result.dart';
import 'package:flutterqiweibao/model/pic_bean.dart';
import 'package:flutterqiweibao/model/pic_result.dart';
import 'package:flutterqiweibao/model/ware/ware.dart';
import 'package:flutterqiweibao/model/ware/ware_edit_intent.dart';
import 'package:flutterqiweibao/model/ware/ware_pic.dart';
import 'package:flutterqiweibao/model/ware/ware_result.dart';
import 'package:flutterqiweibao/tree/dialog/tree_ware_type_dialog.dart';
import 'package:flutterqiweibao/tree/tree.dart';
import 'package:flutterqiweibao/ui/photo_view_wrapper.dart';
import 'package:flutterqiweibao/utils/color_util.dart';
import 'package:flutterqiweibao/utils/contains_util.dart';
import 'package:flutterqiweibao/utils/font_size_util.dart';
import 'package:flutterqiweibao/utils/loading_dialog_util.dart';
import 'package:flutterqiweibao/utils/menu_code_util.dart';
import 'package:flutterqiweibao/utils/quality_unit_util.dart';
import 'package:flutterqiweibao/utils/string_util.dart';
import 'package:flutterqiweibao/utils/toast_util.dart';
import 'package:flutterqiweibao/utils/url_util.dart';
import 'package:flutterqiweibao/utils/ware_is_type_util.dart';
import 'package:image_picker/image_picker.dart';

import '../utils/method_channel_util.dart';

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

  @override
  void initState() {
    getMenuList();
    getIntent();
    super.initState();
  }

  MethodChannel _methodChannel = MethodChannel(MethodChannelUtil.ware_edit);
  getIntent() async {
    _methodChannel.setMethodCallHandler(_methodChannelHandler);
    var map = await _methodChannel.invokeMethod("getIntent");
    print("------------------------getIntent-----------------------:" +
        map.toString());
//    Map<String, dynamic> map = {"add": false, "wareId": 123};
    setState(() {
      WareEditIntent intent = WareEditIntent.fromJson(json.decode(map));
      add = intent.add!;
      wareId = intent.wareId;
      ContainsUtil.token = intent.token!;
      UrlUtil.ROOT = intent.baseUrl!;
      if (!add) {
        queryDetail();
      }
    });
  }

  /// 原生 调用 Flutter的结果回调
  Future<String> _methodChannelHandler(MethodCall call) async {
    print(
        "---------------_methodChannelHandler------------------------ method = ${call.method}");
    switch (call.method) {
      case "callFlutter":
        setState(() {
          _isTypeText = call.arguments.toString();
        });
        break;
    }
    return "";
  }

  Future<void> queryDetail() async {
    EasyLoading.show(status: "加载中...");
    Map<String, dynamic>? params = {"wareId": wareId};
    var response = await Dio().get(UrlUtil.ROOT + UrlUtil.ware_detail,
        queryParameters: params,
        options: Options(headers: {"token": ContainsUtil.token}));
    EasyLoading.dismiss();
    print(response);
    WareResult result = WareResult.fromJson(json.decode(response.toString()));
    if (result.state != null && result.state == true) {
      doUI(result.sysWare!);
    }
  }

  void doUI(Ware ware) {
    setState(() {
      _wareId = ware.wareId;
      _isType = ware.isType!.toString();
      _isTypeText = WareIsTypeUtil.getText(_isType);
      _businessType =
          ware.businessType != null ? ware.businessType.toString() : "0";
      _wareType = ware.waretype != null ? ware.waretype.toString() : "0";
      _wareTypeText = ware.waretypeNm!;
      _wareNameController.text = ware.wareNm!;
      _maxUnitController.text = ware.wareDw!;
      _minUnitController.text = ware.minUnit!;
      _maxWareGgUnitController.text = ware.wareGg!;
      _minWareGgUnitController.text = ware.minWareGg!;
      _maxBarCodeController.text = ware.packBarCode!;
      _sUnitController.text = ware.sUnit != null ? ware.sUnit.toString() : "";
      _maxLetterSort = ware.sortCode!;
      _maxSortController.text = ware.sort != null ? ware.sort.toString() : "";
      _minLetterSort = ware.minSortCode!;
      _minSortController.text =
          ware.minSort != null ? ware.minSort.toString() : "";
      _wareTypeSortController.text =
          ware.waretypeSort != null ? ware.waretypeSort.toString() : "";
      _maxLsPriceController.text =
          ware.lsPrice != null ? ware.lsPrice.toString() : "";
      _minLsPriceController.text =
          ware.minLsPrice != null ? ware.minLsPrice.toString() : "";
      _maxInPriceController.text =
          ware.inPrice != null ? ware.inPrice.toString() : "";
      _minInPriceController.text =
          ware.minInPrice != null ? ware.minInPrice.toString() : "";
      _maxPfPriceController.text =
          ware.wareDj != null ? ware.wareDj.toString() : "";
      _minPfPriceController.text =
          ware.sunitPrice != null ? ware.sunitPrice.toString() : "";
      _innerAccPriceDefaultController.text = ware.innerAccPriceDefault != null
          ? ware.innerAccPriceDefault.toString()
          : "";
      _lowestSalePriceController.text =
          ware.lowestSalePrice != null ? ware.lowestSalePrice.toString() : "";
      _wareFeaturesController.text =
          ware.wareFeatures != null ? ware.wareFeatures.toString() : "";
      _qualityController.text =
          ware.qualityDays != null ? ware.qualityDays.toString() : "";
      _qualityWarnController.text =
          ware.qualityAlert != null ? ware.qualityAlert.toString() : "";
      _qualityValue = ware.qualityUnit != null ? ware.qualityUnit! : 1;
      _quality = QualityUnitUtil.getText(_qualityValue);
      _supId = ware.supId;
      _supType = ware.supType;
      _supName = ware.supName != null ? ware.supName.toString() : "";
      _brandValue = ware.brandId;
      _brandText = ware.brandNm != null ? ware.brandNm.toString() : "";
      _warnQtyController.text =
          ware.warnQty != null ? ware.warnQty.toString() : "";
      _picList.addAll(ware.warePicList!);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios, size: 15),
            onPressed: () {
              Navigator.pop(context);
              _methodChannel.invokeMethod("closeActivity");
            },
          ),
          title: Text(add ? "新建商品" : "修改商品")),
      bottomNavigationBar: Container(
        height: 40,
        margin: const EdgeInsets.all(10),
        child: Offstage(
          offstage: !btnSave,
          child: RaisedButton(
              onPressed: () {
                _save(true);
              },
              child: const Text("保存"),
              textColor: Colors.white,
              color: Colors.blue),
        ),
      ),
      body: Container(
        margin: const EdgeInsets.only(left: 10, right: 10),
        color: Colors.white,
        child: ListView(
          children: [
            Offstage(
              offstage: !viewInfo,
              child:Column(
                children:[
                  SizedBox(
                    child: Column(children: [
                      Container(
                        alignment: Alignment.center,
                        child: IconButton(
                            onPressed: () {
                              _imagePickerByCamera();
                            },
                            icon: const Icon(Icons.photo_camera)),
                      ),
                      Offstage(
                        offstage: _picList.isEmpty ? true : false,
                        child: GridView.builder(
                            shrinkWrap: true,
                            scrollDirection: Axis.vertical,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: _picList.length,
                            gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 5,
                              mainAxisSpacing: 5,
                              crossAxisSpacing: 5,
                            ),
                            itemBuilder: (_, position) => _picItem(position)),
                      )
                    ]),
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
                            onChanged:
                            !add ? null : (value) => _changeRadioValue(value)),
                        Text("实物商品",
                            style: TextStyle(
                                color: ColorUtil.GRAY_6,
                                fontSize: FontSizeUtil.MIDDLE)),
                        Radio(
                            value: "1",
                            groupValue: _businessType,
                            onChanged:
                            !add ? null : (value) => _changeRadioValue(value)),
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
                ]
              )
            ),
            Container(
                height: 40,
                alignment: Alignment.center,
                child: TextButton(
                    onPressed: () {
                      _showWareInfo();
                    },
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
                              isCollapsed: true,//重点，相当于⾼度包裹的意思，必须设置为true，不然有默认奇妙的最⼩⾼度
                              contentPadding:  EdgeInsets.symmetric(horizontal: 8, vertical: 10),//内容内边距，影响⾼度
                              hintText: "请输入商品名称",
                              hintStyle: TextStyle(
                                  color: Color(0xFF999999), fontSize: 13),
                              border: OutlineInputBorder(
                                  borderSide: BorderSide.none)))),
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
                      Text("单位(大):",
                          style: TextStyle(
                              color: ColorUtil.GRAY_6,
                              fontSize: FontSizeUtil.MIDDLE)),
                      Expanded(
                          child: TextField(
                        controller: _maxUnitController,
                        decoration: const InputDecoration(
                          isCollapsed: true,//重点，相当于⾼度包裹的意思，必须设置为true，不然有默认奇妙的最⼩⾼度
                          contentPadding: EdgeInsets.symmetric(horizontal: 8, vertical: 10),//内容内边距，影响⾼度
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
                          isCollapsed: true,//重点，相当于⾼度包裹的意思，必须设置为true，不然有默认奇妙的最⼩⾼度
                          contentPadding: EdgeInsets.symmetric(horizontal: 8, vertical: 10),//内容内边距，影响⾼度
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
            Divider(height: 1, color: ColorUtil.LINE_GRAY),
            Offstage(
              offstage:!viewInfo,
              child:Column(
                children:[
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
                                          isCollapsed: true,//重点，相当于⾼度包裹的意思，必须设置为true，不然有默认奇妙的最⼩⾼度
                                          contentPadding: EdgeInsets.symmetric(horizontal: 8, vertical: 10),//内容内边距，影响⾼度
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
                                          isCollapsed: true,//重点，相当于⾼度包裹的意思，必须设置为true，不然有默认奇妙的最⼩⾼度
                                          contentPadding: EdgeInsets.symmetric(horizontal: 8, vertical: 10),//内容内边距，影响⾼度
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
                  Divider(height: 1, color: ColorUtil.LINE_GRAY),
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
                                      maxLines: 3,
                                      minLines: 1,
                                      inputFormatters: [
                                        FilteringTextInputFormatter.allow(
                                            RegExp("^[a-z0-9A-Z]+")), //只允许输入字母
                                      ],
                                      decoration: InputDecoration(
                                          isCollapsed: true,//重点，相当于⾼度包裹的意思，必须设置为true，不然有默认奇妙的最⼩⾼度
                                          contentPadding: EdgeInsets.symmetric(horizontal: 8, vertical: 10),//内容内边距，影响⾼度
                                          hintText: "如(箱码)",
                                          hintStyle: TextStyle(
                                              color: ColorUtil.GRAY_9,
                                              fontSize: FontSizeUtil.MIDDLE),
                                          border: const OutlineInputBorder(
                                              borderSide: BorderSide.none)),
                                    )),
//                      SizedBox(
//                        width: 30,
//                        child: IconButton(
//                            onPressed: () {
//                            }, icon: const Icon(Icons.scanner)),
//                      )
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
                                      maxLines: 3,
                                      minLines: 1,
                                      inputFormatters: [
                                        FilteringTextInputFormatter.allow(
                                            RegExp("^[a-z0-9A-Z]+")), //只允许输入字母
                                      ],
                                      decoration: InputDecoration(
                                          isCollapsed: true,//重点，相当于⾼度包裹的意思，必须设置为true，不然有默认奇妙的最⼩⾼度
                                          contentPadding: const EdgeInsets.symmetric(horizontal: 8, vertical: 10),//内容内边距，影响⾼度
                                          hintText: "如(瓶码)",
                                          hintStyle: TextStyle(
                                              color: ColorUtil.GRAY_9,
                                              fontSize: FontSizeUtil.MIDDLE),
                                          border: const OutlineInputBorder(
                                              borderSide: BorderSide.none)),
                                    )),
//                      SizedBox(
//                        width: 30,
//                        child: IconButton(
//                            onPressed: () {
//                            }, icon: const Icon(Icons.scanner)),
//                      )
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
                              keyboardType: TextInputType.number,
                              decoration: InputDecoration(
                                  isCollapsed: true,//重点，相当于⾼度包裹的意思，必须设置为true，不然有默认奇妙的最⼩⾼度
                                  contentPadding: const EdgeInsets.symmetric(horizontal: 8, vertical: 10),//内容内边距，影响⾼度
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
                ]
              )
            ),
            Offstage(
              offstage: !btnInfo1,
              child: Column(
                children: [
                  Container(
                    height: 40,
                    alignment: Alignment.center,
                    child: TextButton(
                        onPressed: () {
                          _showWareInfo1();
                        },
                        child: Text("商品辅助信息1" + StringUtil.ARROW_DOWN,
                            style: TextStyle(
                                color: ColorUtil.BLUE,
                                fontSize: FontSizeUtil.BIG))),
                  ),
                  Offstage(
                    offstage: !viewInfo1,
                    child:Column(
                      children:[
                        Offstage(
                            offstage: !btnSortEdit,
                            child: Column(children: [
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
                                                          ? _maxLetterSort +
                                                          StringUtil.ARROW_DOWN
                                                          : "选择" + StringUtil.ARROW_DOWN,
                                                      style: TextStyle(
                                                          color: ColorUtil.BLUE,
                                                          fontSize:
                                                          FontSizeUtil.MIDDLE))),
                                            ),
                                            Expanded(
                                                child: TextField(
                                                  controller: _maxSortController,
                                                  keyboardType: TextInputType.number,
                                                  decoration: InputDecoration(
                                                      isCollapsed: true,//重点，相当于⾼度包裹的意思，必须设置为true，不然有默认奇妙的最⼩⾼度
                                                      contentPadding: const EdgeInsets.symmetric(horizontal: 8, vertical: 10),//内容内边距，影响⾼度
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
                                                          ? _minLetterSort +
                                                          StringUtil.ARROW_DOWN
                                                          : "选择" + StringUtil.ARROW_DOWN,
                                                      style: TextStyle(
                                                          color: ColorUtil.BLUE,
                                                          fontSize:
                                                          FontSizeUtil.MIDDLE))),
                                            ),
                                            Expanded(
                                                child: TextField(
                                                  controller: _minSortController,
                                                  keyboardType: TextInputType.number,
                                                  decoration: InputDecoration(
                                                      isCollapsed: true,//重点，相当于⾼度包裹的意思，必须设置为true，不然有默认奇妙的最⼩⾼度
                                                      contentPadding: const EdgeInsets.symmetric(horizontal: 8, vertical: 10),//内容内边距，影响⾼度
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
                                                  keyboardType: TextInputType.number,
                                                  decoration: InputDecoration(
                                                      isCollapsed: true,//重点，相当于⾼度包裹的意思，必须设置为true，不然有默认奇妙的最⼩⾼度
                                                      contentPadding: const EdgeInsets.symmetric(horizontal: 8, vertical: 10),//内容内边距，影响⾼度
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
                            ])),
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
                                            keyboardType: TextInputType.number,
                                            decoration: InputDecoration(
                                                isCollapsed: true,//重点，相当于⾼度包裹的意思，必须设置为true，不然有默认奇妙的最⼩⾼度
                                                contentPadding: const EdgeInsets.symmetric(horizontal: 8, vertical: 10),//内容内边距，影响⾼度
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
                                            keyboardType: TextInputType.number,
                                            decoration: InputDecoration(
                                                isCollapsed: true,//重点，相当于⾼度包裹的意思，必须设置为true，不然有默认奇妙的最⼩⾼度
                                                contentPadding: const EdgeInsets.symmetric(horizontal: 8, vertical: 10),//内容内边距，影响⾼度
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
                        Offstage(
                          offstage: !btnInPrice,
                          child: Column(children: [
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
                                                keyboardType: TextInputType.number,
                                                decoration: InputDecoration(
                                                    isCollapsed: true,//重点，相当于⾼度包裹的意思，必须设置为true，不然有默认奇妙的最⼩⾼度
                                                    contentPadding: const EdgeInsets.symmetric(horizontal: 8, vertical: 10),//内容内边距，影响⾼度
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
                                                keyboardType: TextInputType.number,
                                                decoration: InputDecoration(
                                                    isCollapsed: true,//重点，相当于⾼度包裹的意思，必须设置为true，不然有默认奇妙的最⼩⾼度
                                                    contentPadding: const EdgeInsets.symmetric(horizontal: 8, vertical: 10),//内容内边距，影响⾼度
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
                          ]),
                        ),
                        Offstage(
                          offstage: !btnPfPrice,
                          child: Column(children: [
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
                                                keyboardType: TextInputType.number,
                                                decoration: InputDecoration(
                                                    isCollapsed: true,//重点，相当于⾼度包裹的意思，必须设置为true，不然有默认奇妙的最⼩⾼度
                                                    contentPadding: const EdgeInsets.symmetric(horizontal: 8, vertical: 10),//内容内边距，影响⾼度
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
                                                keyboardType: TextInputType.number,
                                                decoration: InputDecoration(
                                                    isCollapsed: true,//重点，相当于⾼度包裹的意思，必须设置为true，不然有默认奇妙的最⼩⾼度
                                                    contentPadding: const EdgeInsets.symmetric(horizontal: 8, vertical: 10),//内容内边距，影响⾼度
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
                          ]),
                        ),
                        Offstage(
                          offstage: !btnInnerAccPriceDefault,
                          child: Column(children: [
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
                                                keyboardType: TextInputType.number,
                                                decoration: InputDecoration(
                                                    isCollapsed: true,//重点，相当于⾼度包裹的意思，必须设置为true，不然有默认奇妙的最⼩⾼度
                                                    contentPadding: const EdgeInsets.symmetric(horizontal: 8, vertical: 10),//内容内边距，影响⾼度
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
                          ]),
                        ),
                        Offstage(
                          offstage: !btnLowestSalePrice,
                          child: Column(children: [
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
                                                keyboardType: TextInputType.number,
                                                decoration: InputDecoration(
                                                    isCollapsed: true,//重点，相当于⾼度包裹的意思，必须设置为true，不然有默认奇妙的最⼩⾼度
                                                    contentPadding: const EdgeInsets.symmetric(horizontal: 8, vertical: 10),//内容内边距，影响⾼度
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
                          ]),
                        ),
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
                                                isCollapsed: true,//重点，相当于⾼度包裹的意思，必须设置为true，不然有默认奇妙的最⼩⾼度
                                                contentPadding: const EdgeInsets.symmetric(horizontal: 8, vertical: 10),//内容内边距，影响⾼度
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
                      ]
                    )
                  ),
                ],
              ),
            ),
            Offstage(
              offstage: !btnInfo2,
              child: Column(
                children: [
                  Container(
                    height: 40,
                    alignment: Alignment.center,
                    child: TextButton(
                        onPressed: () {
                          _showWareInfo2();
                        },
                        child: Text("商品辅助信息2" + StringUtil.ARROW_DOWN,
                            style: TextStyle(
                                color: ColorUtil.BLUE,
                                fontSize: FontSizeUtil.BIG))),
                  ),
                  Offstage(
                    offstage:!viewInfo2,
                    child: Column(
                      children:[
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
                                            keyboardType: TextInputType.number,
                                            inputFormatters: [
                                              FilteringTextInputFormatter.allow(
                                                  RegExp("[0-9]"))
                                            ],
                                            decoration: InputDecoration(
                                                isCollapsed: true,//重点，相当于⾼度包裹的意思，必须设置为true，不然有默认奇妙的最⼩⾼度
                                                contentPadding: const EdgeInsets.symmetric(horizontal: 8, vertical: 10),//内容内边距，影响⾼度
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
                                            keyboardType: TextInputType.number,
                                            inputFormatters: [
                                              FilteringTextInputFormatter.allow(
                                                  RegExp("[0-9]"))
                                            ],
                                            decoration: InputDecoration(
                                                isCollapsed: true,//重点，相当于⾼度包裹的意思，必须设置为true，不然有默认奇妙的最⼩⾼度
                                                contentPadding: const EdgeInsets.symmetric(horizontal: 8, vertical: 10),//内容内边距，影响⾼度
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
                                          onPressed: () {
//                            Navigator.of(context).pushNamed("choose_customer");
                                          },
                                          child: Text(
                                              _supName.isNotEmpty
                                                  ? _supName + StringUtil.ARROW_DOWN
                                                  : "选择" + StringUtil.ARROW_DOWN,
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
                                          onPressed: () {
                                            _showDialogBrandList();
                                          },
                                          child: Text(
                                              _brandText.isNotEmpty
                                                  ? _brandText + StringUtil.ARROW_DOWN
                                                  : "选择" + StringUtil.ARROW_DOWN,
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
                                            keyboardType: TextInputType.number,
                                            decoration: InputDecoration(
                                                isCollapsed: true,//重点，相当于⾼度包裹的意思，必须设置为true，不然有默认奇妙的最⼩⾼度
                                                contentPadding: const EdgeInsets.symmetric(horizontal: 8, vertical: 10),//内容内边距，影响⾼度
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
                      ]
                    ),
                  ),
                ],
              ),
            ),
            Offstage(
              offstage: !btnCustomerTypePrice,
              child: Container(
                height: 40,
                alignment: Alignment.center,
                child: TextButton(
                    onPressed: () {},
                    child: Text("查看客户类型价" + StringUtil.ARROW_DOWN,
                        style: TextStyle(
                            color: ColorUtil.BLUE,
                            fontSize: FontSizeUtil.BIG))),
              ),
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
  int? _brandValue;
  String _brandText = "";
  int? _supId;
  String _supName = "";
  int? _supType;
  final TextEditingController _wareNameController = TextEditingController();
  final TextEditingController _maxUnitController = TextEditingController();
  final TextEditingController _minUnitController = TextEditingController();
  final TextEditingController _maxWareGgUnitController =
      TextEditingController();
  final TextEditingController _minWareGgUnitController =
      TextEditingController();
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
  final TextEditingController _innerAccPriceDefaultController =
      TextEditingController();
  final TextEditingController _lowestSalePriceController =
      TextEditingController();
  final TextEditingController _wareFeaturesController = TextEditingController();
  final TextEditingController _qualityController = TextEditingController();
  final TextEditingController _qualityWarnController = TextEditingController();
  final TextEditingController _warnQtyController = TextEditingController();

  void _showDialogWareIsType(BuildContext context) {
    FocusManager.instance.primaryFocus?.unfocus();
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
    FocusManager.instance.primaryFocus?.unfocus();
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

  List<BrandBean> _brandList = [];
  void _showDialogBrandList() async {
    if (_brandList.isEmpty) {
      FocusManager.instance.primaryFocus?.unfocus();
      LoadingDialogUtil.show();
      var response = await Dio().get(UrlUtil.ROOT + UrlUtil.brand_list,
          options: Options(headers: {"token": ContainsUtil.token}));
      LoadingDialogUtil.dismiss();
      print(response);
      BrandListResult result =
          BrandListResult.fromJson(json.decode(response.toString()));
      if (result.state!) {
        _brandList = result.data!;
      } else {
        ToastUtil.error(result.msg);
      }
    }

    if (_brandList.isNotEmpty) {
      showDialog(
          context: context,
          builder: (_) => SimpleDialog(
                title: Text("选择品牌",
                    style: TextStyle(
                        color: ColorUtil.BLUE, fontSize: FontSizeUtil.BIG)),
                children: getItemBrand(_brandList),
              ));
    }
  }

  List<Widget> getItemBrand(list) {
    List<Widget> widgetList = [];
    list.forEach((item) {
      widgetList.add(SimpleDialogOption(
        child: Text(item.name),
        onPressed: () {
          Navigator.pop(context);
          setState(() {
            _brandValue = item.id;
            _brandText = item.name;
          });
        },
      ));
    });
    return widgetList;
  }

  void _showDialogLetter(BuildContext context, bool isMax) {
    FocusManager.instance.primaryFocus?.unfocus();
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
    FocusManager.instance.primaryFocus?.unfocus();
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
  Widget _picItem(int position) {
    WarePic pic = _picList[position];
    return Stack(children: [
      Positioned.fill(
          child: GestureDetector(
        onTap: () {
          zoomPic(context, position);
        },
        child: RepaintBoundary(
          child: ClipRRect(
            borderRadius: BorderRadius.circular(8.0),
            child: Image.network(UrlUtil.ROOT + UrlUtil.ROOT_UPLOAD + pic.pic!,
                fit: BoxFit.cover),
          ),
        ),
      )),
      Positioned(
        right: 0,
        child: GestureDetector(
          onTap: () {
            delPic(pic.pic!, position);
          },
          child: Container(
            decoration: BoxDecoration(
                color: Colors.white, borderRadius: BorderRadius.circular(20)),
            width: 20,
            height: 20,
            child: Icon(
              Icons.close,
              color: ColorUtil.GRAY_9,
              size: 18,
            ),
          ),
        ),
      )
    ]);
  }

  void zoomPic(BuildContext context, final int index) {
    List<String> list = [];
    _picList.forEach((element) {
      list.add(UrlUtil.ROOT + UrlUtil.ROOT_UPLOAD + element.pic!);
    });
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PhotoViewWrapper(
          items: list,
          index: index,
        ),
      ),
    );
  }

  Future<void> uploadPic(String filePath) async {
    EasyLoading.show(status: '加载中...');
    var dio = Dio();
    Map<String, dynamic> map = {};
    map["path"] = "ware";
    map["file"] = await MultipartFile.fromFile(filePath);
    var data = FormData.fromMap(map);
    var response = await dio.post(UrlUtil.ROOT + UrlUtil.upload_pic_single,
        data: data, options: Options(headers: {"token": ContainsUtil.token}));
    print(response);
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
    var response = await dio.post(UrlUtil.ROOT + UrlUtil.del_pic_single,
        data: data, options: Options(headers: {"token": ContainsUtil.token}));
    print(response);
    BaseResult result = BaseResult.fromJson(json.decode(response.toString()));
    setState(() {
      if (result.state != null && result.state == true) {
        EasyLoading.dismiss();
        ToastUtil.success("删除成功");
        _picList.removeAt(index);
      }
    });
  }

  void _showDialogTip(String tip) {
    FocusManager.instance.primaryFocus?.unfocus();
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('温馨提示',
                style: TextStyle(
                    color: ColorUtil.GRAY_3, fontSize: FontSizeUtil.BIG)),
            content: Text(tip,
                style: TextStyle(
                    color: ColorUtil.RED, fontSize: FontSizeUtil.MIDDLE)),
            actions: <Widget>[
              FlatButton(
                child: Text('取消',
                    style: TextStyle(
                        color: ColorUtil.GRAY_9,
                        fontSize: FontSizeUtil.MIDDLE)),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
              FlatButton(
                child: Text('确认',
                    style: TextStyle(
                        color: ColorUtil.BLUE, fontSize: FontSizeUtil.MIDDLE)),
                onPressed: () {
                  Navigator.pop(context);
                  _save(false);
                },
              ),
            ],
          );
        });
  }

  Future<void> _save(barCodeTip) async {
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
      "barCodeTip": barCodeTip,
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
      "brandId": _brandValue,
      "supId": _supId,
      "supName": _supName,
      "supType": _supType,
    };

    LoadingDialogUtil.show();
    var response = await Dio().post(UrlUtil.ROOT + UrlUtil.WARE_SAVE,
        data: data, options: Options(headers: {"token": ContainsUtil.token}));
    LoadingDialogUtil.dismiss();
    print(response);
    BaseResult result = BaseResult.fromJson(json.decode(response.toString()));
    if (100 == result.code) {
      _showDialogTip(result.message!);
    } else if (result.state!) {
      ToastUtil.success("保存成功");
      _methodChannel.invokeMethod("closeActivity");
    } else {
      ToastUtil.error(result.msg);
    }
  }

  bool btnSave = false;
  bool btnInfo1 = false;
  bool btnInfo2 = false;
  bool btnSortEdit = false;
  bool btnPfPrice = false;
  bool btnInPrice = false;
  bool btnInnerAccPriceDefault = false;
  bool btnLowestSalePrice = false;
  bool btnCustomerTypePrice = false;
  bool btnUpdateCustomerTypePrice = false;
  bool viewInfo = true;
  bool viewInfo1 = false;
  bool viewInfo2 = false;
  Future<void> getMenuList() async {
    if (add) {
      btnSave = true;
    }
    LoadingDialogUtil.show();
    var response = await Dio().get(UrlUtil.ROOT + UrlUtil.menu_list,
        options: Options(headers: {"token": ContainsUtil.token}));
    LoadingDialogUtil.dismiss();
    print(response);
    MenuResult result = MenuResult.fromJson(json.decode(response.toString()));
    if (result.state!) {
      List<MenuBean>? applyList = result.applyList;
      if (applyList!.isNotEmpty) {
        //第一层
        applyList.forEach((apply) {
          List<MenuBean>? menuList = apply.children;
          if (menuList!.isNotEmpty) {
            //第二层
            menuList.forEach((menu) {
              if (MenuCodeUtil.ware_manager == menu.applyCode) {
                //第三层
                List<MenuBean>? btnList = menu.children;
                if (btnList!.isNotEmpty) {
                  setState(() {
                    btnList.forEach((btn) {
                      if (!add &&
                          MenuCodeUtil.ware_manager_btn_update ==
                              btn.applyCode) {
                        btnSave = true;
                      }
                      if (MenuCodeUtil.ware_manager_btn_info1 ==
                          btn.applyCode) {
                        btnInfo1 = true;
                      }
                      if (MenuCodeUtil.ware_manager_btn_info2 ==
                          btn.applyCode) {
                        btnInfo2 = true;
                      }
                      if (MenuCodeUtil.ware_manager_btn_sort_edit ==
                          btn.applyCode) {
                        btnSortEdit = true;
                      }
                      if (MenuCodeUtil.ware_manager_btn_pf_price ==
                          btn.applyCode) {
                        btnPfPrice = true;
                      }
                      if (MenuCodeUtil.ware_manager_btn_in_price ==
                          btn.applyCode) {
                        btnInPrice = true;
                      }
                      if (MenuCodeUtil
                              .ware_manager_btn_inner_acc_price_default ==
                          btn.applyCode) {
                        btnInnerAccPriceDefault = true;
                      }
                      if (MenuCodeUtil.ware_manager_btn_lowest_sale_price ==
                          btn.applyCode) {
                        btnLowestSalePrice = true;
                      }
                      if (!add &&
                          MenuCodeUtil.ware_manager_btn_customer_type_price ==
                              btn.applyCode) {
                        btnCustomerTypePrice = true;
                      }
                      if (MenuCodeUtil
                              .ware_manager_btn_update_customer_type_price ==
                          btn.applyCode) {
                        btnUpdateCustomerTypePrice = true;
                      }
                    });
                  });
                }
                return;
              }
            });
          }
        });
      }
    } else {
      ToastUtil.error(result.msg);
    }
  }

  void  _showWareInfo(){
    setState(() {
      viewInfo = true;
      viewInfo1 = false;
      viewInfo2 = false;
    });
  }
  void  _showWareInfo1(){
    setState(() {
      viewInfo = false;
      viewInfo1 = true;
      viewInfo2 = false;
    });
  }
  void  _showWareInfo2(){
    setState(() {
      viewInfo = false;
      viewInfo1 = false;
      viewInfo2 = true;
    });
  }

}
