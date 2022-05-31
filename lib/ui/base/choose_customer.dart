import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutterqiweibao/model/customer/customer_bean.dart';
import 'package:flutterqiweibao/model/customer/customer_page_result.dart';
import 'package:flutterqiweibao/tree/tree.dart';
import 'package:flutterqiweibao/utils/color_util.dart';
import 'package:flutterqiweibao/utils/contains_util.dart';
import 'package:flutterqiweibao/utils/font_size_util.dart';
import 'package:flutterqiweibao/utils/loading_dialog_util.dart';
import 'package:flutterqiweibao/utils/toast_util.dart';
import 'package:flutterqiweibao/utils/url_util.dart';

class ChooseCustomer extends StatefulWidget {

  const ChooseCustomer({Key? key }) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return ChooseCustomerState();
  }
}

class ChooseCustomerState extends State<ChooseCustomer> {
  final List<Tab> tabs = [
    Tab(text: '供应商')
//    Tab(text: '员工'),
//    Tab(text: '客户'),
//    Tab(text: '其他往来单位')
  ];


  @override
  void initState() {
    super.initState();
    queryCustomerPage("0", 1);
  }

  List<CustomerBean> _customerSupList = [];
  List<CustomerBean> _customerList = [];
  List<CustomerBean> _customerUnitList = [];
  int _pageNoSup = 1;
  int _pageNoCustomer = 1;
  int _pageNoUnit = 1;
  void queryCustomerPage(customerTypes, page) async{
    LoadingDialogUtil.show();
    var data = {"size":"20","customerTypes":customerTypes,"loadingPeriod":"true","page":page,"loadingPicture":"true"};
    var response = await Dio().get(UrlUtil.ROOT + UrlUtil.around_customer_page,
        queryParameters: data, options: Options(headers: {"token": ContainsUtil.token}));
    LoadingDialogUtil.dismiss();
    logger.d(response);
    CustomerPageResult result = CustomerPageResult.fromJson(json.decode(response.toString()));
    if (result.state!) {
      if(page == 1){
        switch(customerTypes){
          case "0":
            _customerSupList = [];
            break;
          case "2":
            _customerList = [];
            break;
          case "3":
            _customerList = [];
            break;
        }
      }else{
      }
      setState(() {
        switch(customerTypes){
          case "0":
            _customerSupList.addAll(result.data!.rows!);
            break;
          case "2":
            _customerList.addAll(result.data!.rows!);
            break;
          case "3":
            _customerUnitList.addAll(result.data!.rows!);
            break;
        }
      });
    } else {
      ToastUtil.error(result.msg);
    }
  }


  @override
  Widget build(BuildContext context) {
    return DefaultTabController(length: tabs.length, child: Scaffold(
      appBar: AppBar(
        leading: IconButton(onPressed:(){
          Navigator.pop(context);
        },icon:const Icon(Icons.close)),
        title: Text("供应商"),
        bottom: TabBar(tabs: tabs),
      ),
      body: TabBarView(children: [
        Column(
          children: [
            Container(
              height: 50,
              decoration:BoxDecoration(
                borderRadius: BorderRadius.circular(5),
                border: Border.all(color: ColorUtil.GRAY_9, width: 1),//边框
              ),
              margin: EdgeInsets.all(5),
              child: TextField(
                  decoration:InputDecoration(
                      hintText: "供应商名称",
                      hintStyle: TextStyle(color: ColorUtil.GRAY_9, fontSize: FontSizeUtil.MIDDLE),
                      border: OutlineInputBorder(
                          borderSide: BorderSide.none
                      ),
                      suffixIcon: TextButton(
                        onPressed: (){
                        },
                        child: Text("搜索"),
                      )
                  )
              ),
            ),
            RefreshIndicator(
              onRefresh: () async {
                _pageNoSup = 1;
                queryCustomerPage("0", _pageNoSup);
              },
              child: ListView.builder(
                shrinkWrap: true,
                itemBuilder: (c, i) => _buildItem(c,i),
                itemExtent: 40,
                itemCount: _customerSupList.length,
              ),
           ),
//            RefreshIndicator(child: ListView.builder(
//              shrinkWrap: true,
//              itemBuilder: (c, i) => _buildItem(c,i),
//              itemExtent: 40,
//              itemCount: _customerSupList.length,
//            ), onRefresh: (){
//
//          }),


          ],
        ),
      ]),
    ));
  }

  Widget _buildItem(BuildContext context, int index) {
    final CustomerBean item = _customerSupList[index];
    return Card(child: Center(child: Text(item.khNm!)));
  }




}