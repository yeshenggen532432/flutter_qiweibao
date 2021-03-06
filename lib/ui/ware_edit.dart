import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutterqiweibao/model/base/brand_bean.dart';
import 'package:flutterqiweibao/model/base/brand_list_result.dart';
import 'package:flutterqiweibao/model/base/customer_type_price_bean.dart';
import 'package:flutterqiweibao/model/base/customer_type_price_result.dart';
import 'package:flutterqiweibao/model/base/menu_bean.dart';
import 'package:flutterqiweibao/model/base/menu_result.dart';
import 'package:flutterqiweibao/model/base/sup_bean.dart';
import 'package:flutterqiweibao/model/base_result.dart';
import 'package:flutterqiweibao/model/pic_bean.dart';
import 'package:flutterqiweibao/model/pic_result.dart';
import 'package:flutterqiweibao/model/ware/ware.dart';
import 'package:flutterqiweibao/model/ware/ware_edit_intent.dart';
import 'package:flutterqiweibao/model/ware/ware_pic.dart';
import 'package:flutterqiweibao/model/ware/ware_result.dart';
import 'package:flutterqiweibao/template/base_template.dart';
import 'package:flutterqiweibao/template/row_template.dart';
import 'package:flutterqiweibao/template/ware/ware_edit_template.dart';
import 'package:flutterqiweibao/utils/color_util.dart';
import 'package:flutterqiweibao/utils/contains_util.dart';
import 'package:flutterqiweibao/utils/font_size_util.dart';
import 'package:flutterqiweibao/utils/http/url_manager.dart';
import 'package:flutterqiweibao/utils/loading_dialog_util.dart';
import 'package:flutterqiweibao/utils/log_util.dart';
import 'package:flutterqiweibao/utils/menu_code_util.dart';
import 'package:flutterqiweibao/utils/channel_util.dart';
import 'package:flutterqiweibao/utils/quality_unit_util.dart';
import 'package:flutterqiweibao/utils/toast_util.dart';
import 'package:flutterqiweibao/widget/dialog/bottom_dialog.dart';
import 'package:flutterqiweibao/utils/ware_is_type_util.dart';
import 'package:flutterqiweibao/widget/photo/photo_view_wrapper.dart';
import 'package:flutterqiweibao/widget/tree/dialog/tree_ware_type_dialog.dart';
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

  @override
  void initState() {
    initMethodChannel();
    initEventChannel();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          leading: TitleBackView(methodChannel: _methodChannel),
          title: Text(add ? "????????????" : "????????????")),
      bottomNavigationBar: Offstage(
        offstage: !btnSave,
        child: ButtonEdit(
          "??????",
          onClick: () {
            _save(true);
          },
        ),
      ),
      body: Container(
        margin: const EdgeInsets.only(left: 10, right: 10),
        color: Colors.white,
        child: ListView(
          children: [
            Offstage(
                offstage: !viewInfo,
                child: Column(children: [
                  SizedBox(
                    child: Column(children: [
                      Container(
                        alignment: Alignment.center,
                        child: IconButton(
                            onPressed: () {
                              showDialogPic();
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
                  RowLabelMenu(
                      label: "????????????:",
                      onClick: () {
                        _showDialogWareIsType(context);
                      },
                      menuValue: _isTypeText),
                  RowLabelTwoRadio(
                      label: "??????????????????:",
                      groupValue: _businessType,
                      leftRadioValue: "0",
                      onLeftChanged:
                          !add ? null : (value) => _changeRadioValue(value),
                      leftLabel: "????????????",
                      rightRadioValue: "1",
                      onRightChanged:
                          !add ? null : (value) => _changeRadioValue(value),
                      rightLabel: "????????????"),
                  RowLabelMenu(
                      label: "????????????:",
                      onClick: () {
                        _showDialogWareType(context);
                      },
                      menuValue: _wareTypeText),
                ])),
            RowButton("??????????????????", appendDown: true, onClick: () {
              _showWareInfo();
            }),
            RowLabelEdit(
                controller: _wareNameController,
                label: "????????????2:",
                hint: "?????????????????????2"),
            RowTwoLabelEdit(
              leftController: _maxUnitController,
              leftLabel: "??????(???):",
              leftHint: "??????",
              rightController: _minUnitController,
              rightLabel: "??????(???):",
              rightHint: "??????",
            ),
            Offstage(
                offstage: !viewInfo,
                child: Column(children: [
                  RowTwoLabelEdit(
                    leftController: _maxWareGgUnitController,
                    leftLabel: "??????(???):",
                    leftHint: "???500ml*6",
                    rightController: _minWareGgUnitController,
                    rightLabel: "??????(???):",
                    rightHint: "???500ml",
                  ),
                  RowTwoLabelEditIcon(
                      leftController: _maxBarCodeController,
                      leftLabel: "??????(???):",
                      leftHint: "???(??????)",
                      onLeftClick: () {
                        _methodChannel.invokeMethod("getScan", true);
                      },
                      leftIcon: Image.asset("assets/images/ic_scan_blue.png"),
                      rightController: _minBarCodeController,
                      rightLabel: "??????(???):",
                      rightHint: "???(??????)",
                      onRightClick: () {
                        _methodChannel.invokeMethod("getScan", false);
                      },
                      rightIcon: Image.asset("assets/images/ic_scan_blue.png")),
                  RowLabelTwoEditLabel(
                      label: "????????????????????????:",
                      leftController: TextEditingController(text: "1"),
                      leftEditEnable: false,
                      leftLabel: "*?????????=",
                      rightController: _sUnitController,
                      rightInputType: TextInputType.number,
                      rightLabel: "*?????????"),
                ])),
            Offstage(
              offstage: !btnInfo1,
              child: Column(
                children: [
                  RowButton("??????????????????1", appendDown: true, onClick: () {
                    _showWareInfo1();
                  }),
                  Offstage(
                      offstage: !viewInfo1,
                      child: Column(children: [
                        Offstage(
                            offstage: !btnSortEdit,
                            child: Column(children: [
                              RowTwoLabelButtonEdit(
                                  leftController: _maxSortController,
                                  leftLabel: "?????????(???):",
                                  onLeftClick: () {
                                    _showDialogLetter(context, true);
                                  },
                                  leftButtonValue: _maxLetterSort,
                                  rightController: _minSortController,
                                  rightLabel: "?????????(???):",
                                  onRightClick: () {
                                    _showDialogLetter(context, false);
                                  },
                                  rightButtonValue: _minLetterSort),
                              RowLabelEdit(
                                  controller: _wareTypeSortController,
                                  label: "????????????:")
                            ])),
                        RowTwoLabelEdit(
                            leftController: _maxLsPriceController,
                            leftLabel: "??????(???):",
                            leftInputType: TextInputType.number,
                            rightController: _minLsPriceController,
                            rightLabel: "??????(???):",
                            rightInputType: TextInputType.number),
                        Offstage(
                          offstage: !btnInPrice,
                          child: RowTwoLabelEdit(
                              leftController: _maxInPriceController,
                              leftLabel: "?????????(???):",
                              leftInputType: TextInputType.number,
                              rightController: _minInPriceController,
                              rightLabel: "?????????(???):",
                              rightInputType: TextInputType.number),
                        ),
                        Offstage(
                          offstage: !btnPfPrice,
                          child: RowTwoLabelEdit(
                              leftController: _maxPfPriceController,
                              leftLabel: "?????????(???):",
                              leftInputType: TextInputType.number,
                              rightController: _minPfPriceController,
                              rightLabel: "?????????(???):",
                              rightInputType: TextInputType.number),
                        ),
                        Offstage(
                          offstage: !btnInnerAccPriceDefault,
                          child: RowLabelEdit(
                            controller: _innerAccPriceDefaultController,
                            label: "???????????????(??????):",
                            inputType: TextInputType.number,
                            tip: "????????????????????????(???)",
                          ),
                        ),
                        Offstage(
                          offstage: !btnLowestSalePrice,
                          child: RowLabelEdit(
                            controller: _lowestSalePriceController,
                            label: "???????????????(???):",
                            inputType: TextInputType.number,
                          ),
                        ),
                        RowLabelEdit(
                          controller: _wareFeaturesController,
                          label: "????????????:",
                          hint: "?????????????????????????????????(??????????????????4??????)",
                        ),
                      ])),
                ],
              ),
            ),
            Offstage(
              offstage: !btnInfo2,
              child: Column(
                children: [
                  RowButton("??????????????????2", appendDown: true, onClick: () {
                    _showWareInfo2();
                  }),
                  Offstage(
                    offstage: !viewInfo2,
                    child: Column(children: [
                      WareRowLabelEditThree(
                        leftController: _qualityController,
                        leftLabel: "?????????:",
                        leftInputType: TextInputType.number,
                        leftTwoValue: _quality,
                        onLeftClick: () {
                          _showDialogQuality(context);
                        },
                        rightController: _qualityWarnController,
                        rightLabel: "???????????????:",
                        rightInputType: TextInputType.number,
                      ),
                      RowTwoLabelButton(
                        onLeftClick: () {
                          _chooseSup(context);
                        },
                        leftLabel: "?????????:",
                        leftValue: _supName,
                        onRightClick: () {
                          _showDialogBrandList();
                        },
                        rightLabel: "????????????:",
                        rightValue: _brandText,
                      ),
                      RowLabelEdit(
                          controller: _warnQtyController, label: "??????????????????:")
                    ]),
                  ),
                ],
              ),
            ),
            Offstage(
              offstage: !btnCustomerTypePrice,
              child: RowButton("?????????????????????", appendDown: true, onClick: () {
                _showDialogCustomerTypePrice();
              }),
            ),
          ],
        ),
      ),
    );
  }

  MethodChannel _methodChannel = MethodChannel(ChannelUtil.method_channel_ware_edit);
  initMethodChannel(){
    if (ContainsUtil.release) {
//      _methodChannel.setMethodCallHandler(_methodChannelHandler);
      _methodChannel.setMethodCallHandler((call) async{
        switch (call.method) {
          case "setScan":
            setState(() {
              Map<String, dynamic> map = Map<String, dynamic>.from(call.arguments);
              bool max = map["max"];
              if (max) {
                _maxBarCodeController.text = map["barcode"];
              } else {
                _minBarCodeController.text = map["barcode"];
              }
            });
            break;
        }
      });
//      var map = await _methodChannel.invokeMethod("getIntent");
//      WareEditIntent intent = WareEditIntent.fromJson(json.decode(map));
//      setState(() {
//        add = intent.add!;
//        wareId = intent.wareId;
//        ContainsUtil.token = intent.token!;
//        UrlManager.ROOT = intent.baseUrl!;
//      });
    }
//    setState(() {
//      getMenuList();
//      if (!add) {
//        queryDetail();
//      }
//    });
  }

  EventChannel _eventChannel = EventChannel(ChannelUtil.event_channel_ware_edit);
  void initEventChannel() {
    if(ContainsUtil.release){
      _eventChannel.receiveBroadcastStream().listen((event) async {
        setState(() {
          WareEditIntent intent =
          WareEditIntent.fromJson(Map<String, dynamic>.from(event));
          setState(() {
            add = intent.add!;
            wareId = intent.wareId;
            ContainsUtil.token = intent.token!;
            UrlManager.ROOT = intent.baseUrl!;
            getMenuList();
            if (!add) {
              queryDetail();
            }
          });
        });
      });
    }else{
      getMenuList();
      if (!add) {
        queryDetail();
      }
    }
  }

  Future<void> queryDetail() async {
    EasyLoading.show(status: "?????????...");
    Map<String, dynamic>? params = {"wareId": wareId};
    var response = await Dio().get(UrlManager.ROOT + UrlManager.ware_detail,
        queryParameters: params,
        options: Options(headers: {"token": ContainsUtil.token}));
    EasyLoading.dismiss();
    LogUtil.d(response);
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
      _minBarCodeController.text = ware.beBarCode!;
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

  /**
   * ???????????????
   */
  void _chooseSup(BuildContext context) {
    FocusManager.instance.primaryFocus?.unfocus();
    Navigator.of(context).pushNamed("choose_customer").then((value) {
      SupBean sup = SupBean.fromJson(json.decode(value.toString()));
      LogUtil.d(sup.supName);
      setState(() {
        _supId = sup.supId;
        _supType = sup.supType;
        _supName = sup.supName!;
      });
    });
  }

  String _businessType = "0";
  String _isType = "0";
  String _isTypeText = "???????????????";
  String _wareType = "";
  String _wareTypeText = "?????????";
  String _maxLetterSort = "";
  String _minLetterSort = "";
  String _quality = "???";
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
              title: Text("??????????????????",
                  style: TextStyle(
                      color: ColorUtil.BLUE, fontSize: FontSizeUtil.BIG)),
              children: [
                SimpleDialogOption(
                  child: const Text("???????????????"),
                  onPressed: () {
                    _changeWareIsType("0", "???????????????");
                  },
                ),
                SimpleDialogOption(
                  child: const Text("???????????????"),
                  onPressed: () {
                    _changeWareIsType("1", "???????????????");
                  },
                ),
                SimpleDialogOption(
                  child: const Text("??????????????????"),
                  onPressed: () {
                    _changeWareIsType("2", "??????????????????");
                  },
                ),
                SimpleDialogOption(
                  child: const Text("???????????????"),
                  onPressed: () {
                    _changeWareIsType("3", "???????????????");
                  },
                ),
                SimpleDialogOption(
                  child: const Text("???????????????"),
                  onPressed: () {
                    _changeWareIsType("4", "???????????????");
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
      var response = await Dio().get(UrlManager.ROOT + UrlManager.brand_list,
          options: Options(headers: {"token": ContainsUtil.token}));
      LoadingDialogUtil.dismiss();
      LogUtil.d(response);
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
                title: Text("????????????",
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
              title: Text("??????????????????",
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
              title: Text("?????????",
                  style: TextStyle(
                      color: ColorUtil.BLUE, fontSize: FontSizeUtil.BIG)),
              children: [
                SimpleDialogOption(
                  child: const Text("???"),
                  onPressed: () {
                    _changeQuality("???", 3);
                  },
                ),
                SimpleDialogOption(
                  child: const Text("???"),
                  onPressed: () {
                    _changeQuality("???", 2);
                  },
                ),
                SimpleDialogOption(
                  child: const Text("???"),
                  onPressed: () {
                    _changeQuality("???", 1);
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

  void showDialogPic() {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return BottomDialog(
            list: ["??????", "??????"],
            onChanged: (int index) {
              LogUtil.d(index);
              if (0 == index) {
                _imagePickerByCamera();
              } else {
                _imagePickerByGallery();
              }
            },
          );
        });
  }

  void _imagePickerByCamera() async {
    ImagePicker _picker = ImagePicker();
    final XFile? photo = await _picker.pickImage(source: ImageSource.camera);
    uploadPic(photo!.path);
  }

  void _imagePickerByGallery() async {
    ImagePicker _picker = ImagePicker();
    final XFile? photo = await _picker.pickImage(source: ImageSource.gallery);
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
            child: Image.network(
                UrlManager.ROOT + UrlManager.ROOT_UPLOAD + pic.pic!,
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
      list.add(UrlManager.ROOT + UrlManager.ROOT_UPLOAD + element.pic!);
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
    EasyLoading.show(status: '?????????...');
    var dio = Dio();
    Map<String, dynamic> map = {};
    map["path"] = "ware";
    map["file"] = await MultipartFile.fromFile(filePath);
    var data = FormData.fromMap(map);
    var response = await dio.post(
        UrlManager.ROOT + UrlManager.upload_pic_single,
        data: data,
        options: Options(headers: {"token": ContainsUtil.token}));
    LogUtil.d(response);
    PicResult picResult = PicResult.fromJson(json.decode(response.toString()));
    setState(() {
      EasyLoading.dismiss();
      PicBean picBean = picResult.data;
      _picList.add(WarePic.fromUploadPic(picBean));
    });
  }

  Future<void> delPic(String filePath, int index) async {
    EasyLoading.show(status: '?????????...');
    var dio = Dio();
    Map<String, dynamic> map = {};
    map["object"] = filePath;
    var data = FormData.fromMap(map);
    var response = await dio.post(UrlManager.ROOT + UrlManager.del_pic_single,
        data: data, options: Options(headers: {"token": ContainsUtil.token}));
    LogUtil.d(response);
    BaseResult result = BaseResult.fromJson(json.decode(response.toString()));
    setState(() {
      if (result.state != null && result.state == true) {
        EasyLoading.dismiss();
        ToastUtil.success("????????????");
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
            title: Text('????????????',
                style: TextStyle(
                    color: ColorUtil.GRAY_3, fontSize: FontSizeUtil.BIG)),
            content: Text(tip,
                style: TextStyle(
                    color: ColorUtil.RED, fontSize: FontSizeUtil.MIDDLE)),
            actions: <Widget>[
              FlatButton(
                child: Text('??????',
                    style: TextStyle(
                        color: ColorUtil.GRAY_9,
                        fontSize: FontSizeUtil.MIDDLE)),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
              FlatButton(
                child: Text('??????',
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
    var response = await Dio().post(UrlManager.ROOT + UrlManager.WARE_SAVE,
        data: data, options: Options(headers: {"token": ContainsUtil.token}));
    LoadingDialogUtil.dismiss();
    LogUtil.d(response);
    BaseResult result = BaseResult.fromJson(json.decode(response.toString()));
    if (100 == result.code) {
      _showDialogTip(result.message!);
    } else if (result.state!) {
      ToastUtil.success("????????????");
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
    var response = await Dio().get(UrlManager.ROOT + UrlManager.menu_list,
        options: Options(headers: {"token": ContainsUtil.token}));
    LoadingDialogUtil.dismiss();
    LogUtil.d(response);
    Map<String, dynamic> map = response.data;

//    Map<String, dynamic> map =  await HttpManager.getInstance().get(UrlManager.menu_list);

    MenuResult result = MenuResult.fromJson(map);
    LogUtil.d(result);
    if (result.state!) {
      List<MenuBean>? applyList = result.applyList;
      if (applyList!.isNotEmpty) {
        //?????????
        applyList.forEach((apply) {
          List<MenuBean>? menuList = apply.children;
          if (menuList!.isNotEmpty) {
            //?????????
            menuList.forEach((menu) {
              if (MenuCodeUtil.ware_manager == menu.applyCode) {
                //?????????
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

  void _showWareInfo() {
    setState(() {
      viewInfo = true;
      viewInfo1 = false;
      viewInfo2 = false;
    });
  }

  void _showWareInfo1() {
    setState(() {
      viewInfo = false;
      viewInfo1 = true;
      viewInfo2 = false;
    });
  }

  void _showWareInfo2() {
    setState(() {
      viewInfo = false;
      viewInfo1 = false;
      viewInfo2 = true;
    });
  }

  Future<void> getCustomerTypePriceList() async {
    LoadingDialogUtil.show();
    var response = await Dio().get(
        UrlManager.ROOT + UrlManager.customer_type_price_list,
        queryParameters: {"wareId": wareId},
        options: Options(headers: {"token": ContainsUtil.token}));
    LoadingDialogUtil.dismiss();
    LogUtil.d(response);
    CustomerTypePriceResult result =
        CustomerTypePriceResult.fromJson(json.decode(response.toString()));
    if (result.state!) {
      _customerTypePriceList = [];
      _customerTypePriceList.addAll(result.data!);
    } else {
      ToastUtil.error(result.msg);
    }
  }

  List<CustomerTypePriceBean> _customerTypePriceList = [];
  _showDialogCustomerTypePrice() async {
//    getCustomerTypePriceList();----TODO ???????????????????????????
    LoadingDialogUtil.show();
    var response = await Dio().get(
        UrlManager.ROOT + UrlManager.customer_type_price_list,
        queryParameters: {"wareId": wareId},
        options: Options(headers: {"token": ContainsUtil.token}));
    LoadingDialogUtil.dismiss();
    LogUtil.d(response);
    CustomerTypePriceResult result =
        CustomerTypePriceResult.fromJson(json.decode(response.toString()));
    if (result.state!) {
      _customerTypePriceList = [];
      _customerTypePriceList.addAll(result.data!);
    } else {
      ToastUtil.error(result.msg);
    }

    if (_customerTypePriceList.isNotEmpty) {
      return showDialog<String>(
          context: context,
          builder: (context) {
            return Dialog(
              child: Column(
                children: [
                  Container(
                    height: 50,
                    alignment: Alignment.center,
                    child: Text(
                      '???????????????',
                      style: TextStyle(
                          color: ColorUtil.BLUE, fontSize: FontSizeUtil.BIG),
                    ),
                  ),
                  Divider(
                    color: ColorUtil.LINE_GRAY,
                    height: 1,
                  ),
                  Offstage(
                    offstage: !btnUpdateCustomerTypePrice,
                    child: Container(
                      height: 40,
                      alignment: Alignment.center,
                      child: Row(
                        children: [
                          Expanded(
                            child: Container(
                              margin: const EdgeInsets.only(left: 5),
                              child: Text("???????????????????????????????????????????????????????????????????????????",
                                  style: TextStyle(
                                      color: ColorUtil.RED,
                                      fontSize: FontSizeUtil.SMALL)),
                            ),
                          ),
//                          Container(
//                            width: 70,
//                            alignment: Alignment.center,
//                            margin: const EdgeInsets.only(right: 5, bottom: 5),
//                            child: TextButton(
//                                onPressed: () {
//                                },
//                                child: Text("???",
//                                    style: TextStyle(
//                                        color: ColorUtil.BLUE,
//                                        fontSize: FontSizeUtil.BIG))),
//                          ),
//                          Container(
//                            width: 70,
//                            alignment: Alignment.center,
//                            margin: const EdgeInsets.only(right: 5, bottom: 5),
//                            child: TextButton(
//                                onPressed: () {
//                                },
//                                child: Text("???",
//                                    style: TextStyle(
//                                        color: ColorUtil.BLUE,
//                                        fontSize: FontSizeUtil.BIG))),
//                          ),
                        ],
                      ),
                    ),
                  ),
                  Expanded(
                      child: ListView.builder(
                          itemCount: _customerTypePriceList.length,
                          itemBuilder: (BuildContext context, int index) {
                            return Row(
                              children: [
                                Expanded(
                                  child: Container(
                                    margin: const EdgeInsets.only(left: 5),
                                    child: Text(_customerTypePriceList[index]
                                        .customerTypeName!),
                                  ),
                                ),
                                CustomerTypePriceEdit(
                                    enable: btnUpdateCustomerTypePrice,
                                    max: true,
                                    wareId: wareId!,
                                    customerTypeId:
                                        _customerTypePriceList[index]
                                            .customerTypeId!,
                                    value: _customerTypePriceList[index]
                                                .salePrice ==
                                            null
                                        ? ""
                                        : _customerTypePriceList[index]
                                            .salePrice
                                            .toString()),
                                CustomerTypePriceEdit(
                                    enable: btnUpdateCustomerTypePrice,
                                    max: false,
                                    wareId: wareId!,
                                    customerTypeId:
                                        _customerTypePriceList[index]
                                            .customerTypeId!,
                                    value: _customerTypePriceList[index]
                                                .minSalePrice ==
                                            null
                                        ? ""
                                        : _customerTypePriceList[index]
                                            .minSalePrice
                                            .toString()),
                              ],
                            );
                          })),
                ],
              ),
            );
          });
    }
  }
}

class CustomerTypePriceEdit extends StatefulWidget {
  String value;
  int customerTypeId;
  int wareId;
  bool max;
  bool enable = false;
  CustomerTypePriceEdit(
      {Key? key,
      required this.max,
      required this.value,
      required this.customerTypeId,
      required this.enable,
      required this.wareId})
      : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return CustomerTypePriceEditState();
  }
}

class CustomerTypePriceEditState extends State<CustomerTypePriceEdit>
    with AutomaticKeepAliveClientMixin {
  TextEditingController _controller = TextEditingController();
  FocusNode _focusNode = FocusNode();

  @override
  bool get wantKeepAlive => true; //?????????????????????get wantKeepAlive????????????true

  @override
  void initState() {
    super.initState();
    _controller.text = widget.value;
    _focusNode.addListener(() {
      if (!_focusNode.hasFocus) {
        LogUtil.d("????????????:" + _controller.text);
        String field = "minSalePrice";
        if (widget.max) {
          field = "salePrice";
        }
        _updateCustomerTypePrice(
            _controller.text, field, widget.customerTypeId, widget.wareId);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 70,
      margin: const EdgeInsets.only(bottom: 5, right: 5),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5),
        border: Border.all(color: ColorUtil.edit_box_gray, width: 1), //??????
      ),
      child: TextField(
          enabled: widget.enable,
          controller: _controller,
          focusNode: _focusNode,
          style: TextStyle(
              color: widget.enable ? ColorUtil.GRAY_3 : ColorUtil.GRAY_9),
          inputFormatters: [FilteringTextInputFormatter.allow(RegExp("[0-9]"))],
          decoration: const InputDecoration(
            isCollapsed: true,
            contentPadding: EdgeInsets.all(8),
            border: OutlineInputBorder(borderSide: BorderSide.none),
          )),
    );
  }

  Future<void> _updateCustomerTypePrice(
      String price, String field, int customerTypeId, int wareId) async {
    LoadingDialogUtil.show();
    var data = {
      "price": price,
      "field": field,
      "customerTypeId": customerTypeId,
      "wareId": wareId
    };
    var response = await Dio().post(
        UrlManager.ROOT + UrlManager.update_customer_type_price,
        queryParameters: data,
        options: Options(headers: {"token": ContainsUtil.token}));
    LoadingDialogUtil.dismiss();
    LogUtil.d(response);
    BaseResult result = BaseResult.fromJson(json.decode(response.toString()));
    if (result.state!) {
      ToastUtil.success("????????????");
    } else {
      ToastUtil.error(result.msg);
    }
  }
}
