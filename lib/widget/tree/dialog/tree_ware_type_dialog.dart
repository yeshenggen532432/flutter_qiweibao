import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutterqiweibao/utils/color_util.dart';
import 'package:flutterqiweibao/utils/contains_util.dart';
import 'package:flutterqiweibao/utils/http/http_manager.dart';
import 'package:flutterqiweibao/utils/loading_dialog_util.dart';
import 'package:flutterqiweibao/utils/toast_util.dart';
import '../../../utils/http/url_manager.dart';
import 'package:flutterqiweibao/widget/tree/tree.dart';

class TreeWareTypeDialog extends Dialog {
  String isType;
  String businessType;
  List<Map<String, dynamic>> checkData;
  final Function okCallBack;        //右边回调
  TreeWareTypeDialog({Key? key, required this.checkData, required this.okCallBack, required this.isType, required this.businessType}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TreeWareTypeContent(checkData:checkData, okCallBack:okCallBack, isType: isType, businessType: businessType,);
  }
}

class TreeWareTypeContent extends StatefulWidget{
  String isType;
  String businessType;
  List<Map<String, dynamic>> checkData;
  final Function okCallBack;        //右边回调
  TreeWareTypeContent({Key? key, required this.checkData, required this.okCallBack, required this.isType, required this.businessType}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return TreeWareTypeState();
  }
}

class TreeWareTypeState extends State<TreeWareTypeContent>{
  List<Map<String, dynamic>> data = [];

  @override
  void initState() {
    super.initState();
    loadData();
  }

  loadData() async {

    bool showKindType = true;
    bool showServiceType = false;
    if(widget.businessType=="1"){
      showKindType = false;
      showServiceType = true;
    }
    Map<String, dynamic>? params = {};
    params["noCompany"] = 0;
    params["showCarType"] = false;
    params["showOftenType"] = false;
    params["showFavType"] = false;
    params["showGroupType"] = false;
    params["showKindType"] = showKindType;
    params["showServiceType"] = showServiceType;
    params["businessType"] = widget.businessType;
    params["isType"] = widget.isType == "4"? "0": widget.isType;//联盟商品类-传“库存商品类”的值

    LoadingDialogUtil.show();
    var response = await Dio().get(
        UrlManager.ROOT + UrlManager.WARE_TYPE_TREE,
        queryParameters: params,
        options:
          Options(headers: {"token": ContainsUtil.token})
        );
    LoadingDialogUtil.dismiss();
    Map<String, dynamic> map = response.data;

//    Map<String, dynamic> map = HttpManager.getInstance().get(UrlManager.WARE_TYPE_TREE, params:params);
    setState(() {
      data.clear();
      if(null != map && map["state"]){
        map['data'].forEach((item){
          item['waretypePid']=-1;
          item['waretypeId']=0;
          data.add(item);
          addData(item['typeList']);
        });
      }else{
        ToastUtil.error(map["msg"]);
      }
    });
  }

  void addData(var typeList){
    if(typeList != null){
      typeList.forEach((item){
        data.add(item);
        addData(item['typeList']);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    List<Map<String, dynamic>> checkedList = widget.checkData;
    return Material(
      type: MaterialType.transparency,
      child: Center(
        child: Container(
          margin: const EdgeInsets.all(45),
          decoration: BoxDecoration(
              color: Colors.white, borderRadius: BorderRadius.circular(10)),
          height: 420,
          child: Column(
            children: [
              Container(
                height: 40,
                alignment: Alignment.center,
                child: const Text("温馨提示"),
              ),
              Divider(
                height: 1,
                color: ColorUtil.LINE_GRAY,
              ),
              Expanded(
                  child: data.isNotEmpty
                      ? FlutterTreePro(
                    listData: data,
                    initialListData: widget.checkData,
                    single: true,
                    config: const Config(
                      parentId: 'waretypePid',
                      id: 'waretypeId',
                      dataType: DataType.DataList,
                      label: 'waretypeNm',
                    ),
                    onChecked: (List<Map<String, dynamic>> list) {
                      checkedList = list;
                    },
                  )
                      : const Center(child: Text("暂无数据"))),
              Divider(
                height: 1,
                color: ColorUtil.LINE_GRAY,
              ),
              Flex(
                direction: Axis.horizontal,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  MaterialButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: const Text("取消"),
                  ),
                  MaterialButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                      widget.okCallBack(checkedList);
                    },
                    child: const Text( "确定", style: TextStyle(color: Colors.blue),
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

}
