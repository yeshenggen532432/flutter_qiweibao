import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutterqiweibao/model/base/sup_bean.dart';
import 'package:flutterqiweibao/model/customer/customer_bean.dart';
import 'package:flutterqiweibao/model/customer/customer_page_result.dart';
import 'package:flutterqiweibao/utils/color_util.dart';
import 'package:flutterqiweibao/utils/contains_util.dart';
import 'package:flutterqiweibao/utils/font_size_util.dart';
import 'package:flutterqiweibao/utils/loading_dialog_util.dart';
import 'package:flutterqiweibao/utils/toast_util.dart';
import 'package:flutterqiweibao/utils/url_util.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class ChooseCustomer extends StatefulWidget {
  const ChooseCustomer({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return ChooseCustomerState();
  }
}

class ChooseCustomerState extends State<ChooseCustomer>
    with SingleTickerProviderStateMixin {
  final List<Tab> tabs = [
    const Tab(text: '供应商'),
//    Tab(text: '员工'),
    const Tab(text: '客户'),
    const Tab(text: '其他往来单位')
  ];

  late TabController _tabController;
  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: tabs.length, vsync: this);
    _tabController.addListener(() {
      //点击tab回调一次，滑动切换tab不会回调
      if (_tabController.index.toDouble() == _tabController.animation!.value) {
        print("ysl${_tabController.index}");
      }
    });
    queryCustomerPage("0", 1);
    queryCustomerPage("2", 1);
    queryCustomerPage("3", 1);
  }

  //销毁时调用
  @override
  void dispose() {
    super.dispose();
    _tabController.dispose();
  }

  List<CustomerBean> _supList = [];
  List<CustomerBean> _customerList = [];
  List<CustomerBean> _unitList = [];
  int _pageNoSup = 1;
  int _pageNoCustomer = 1;
  int _pageNoUnit = 1;
  void queryCustomerPage(customerTypes, page) async {
    String? search;
    switch (customerTypes) {
      case "0":
        search = _supEditController.text;
        break;
      case "2":
        search = _customerEditController.text;
        break;
      case "3":
        search = _unitEditController.text;
        break;
    }
    LoadingDialogUtil.show();
    var data = {
      "keyword": search,
      "size": "20",
      "customerTypes": customerTypes,
      "loadingPeriod": "true",
      "page": page,
      "loadingPicture": "true"
    };
    var response = await Dio().get(UrlUtil.ROOT + UrlUtil.around_customer_page,
        queryParameters: data,
        options: Options(headers: {"token": ContainsUtil.token}));
    LoadingDialogUtil.dismiss();
    print(response);
    CustomerPageResult result =
        CustomerPageResult.fromJson(json.decode(response.toString()));
    List<CustomerBean> list = result.data!.rows!;
    if (result.state!) {
      if (page == 1) {
        switch (customerTypes) {
          case "0":
            _supList = [];
            _refreshSupController.refreshCompleted(resetFooterState:true);
            break;
          case "2":
            _customerList = [];
            _refreshCustomerController.refreshCompleted(resetFooterState:true);
            break;
          case "3":
            _unitList = [];
            _refreshUnitController.refreshCompleted(resetFooterState:true);
            break;
        }
      } else {
        switch (customerTypes) {
          case "0":
            if(list.isNotEmpty){
              _refreshSupController.loadComplete();
            }else{
              _refreshSupController.loadNoData();
            }
            break;
          case "2":
            if(list.isNotEmpty){
              _refreshCustomerController.loadComplete();
            }else{
              _refreshCustomerController.loadNoData();
            }
            break;
          case "3":
            if(list.isNotEmpty){
              _refreshUnitController.loadComplete();
            }else{
              _refreshUnitController.loadNoData();
            }
            break;
        }
      }
      setState(() {
        switch (customerTypes) {
          case "0":
            _supList.addAll(list);
            break;
          case "2":
            _customerList.addAll(list);
            break;
          case "3":
            _unitList.addAll(list);
            break;
        }
      });
    } else {
      ToastUtil.error(result.msg);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, size: 15),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: const Text("供应商"),
        bottom: TabBar(controller: _tabController, tabs: tabs),
      ),
      body: TabBarView(
//          physics: NeverScrollableScrollPhysics(), //禁止tab左右滑动
          controller: _tabController,
          children: [
            Column(
              children: [
                Container(
                  height: 45,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5),
                    border: Border.all(
                        color: ColorUtil.edit_box_gray, width: 1), //边框
                  ),
                  margin: const EdgeInsets.all(5),
                  child: TextField(
                      controller: _supEditController,
                      decoration: InputDecoration(
                          isCollapsed: true,
                          contentPadding: EdgeInsets.all(8),
                          hintText: "供应商名称",
                          hintStyle: TextStyle(
                              color: ColorUtil.GRAY_9,
                              fontSize: FontSizeUtil.BIG),
                          border: const OutlineInputBorder(
                              borderSide: BorderSide.none),
                          suffixIcon: RaisedButton(
                            onPressed: () {
                              _pageNoSup = 1;
                              queryCustomerPage("0", _pageNoSup);
                            },
                            color: ColorUtil.BLUE,
                            textColor: ColorUtil.White,
                            child: const Text("搜索"),
                          ))),
                ),
                Expanded(
                    child: SmartRefresher(
                  controller: _refreshSupController,
                  enablePullDown: true,
                  enablePullUp: true,
                  onRefresh: () {
                    _pageNoSup = 1;
                    queryCustomerPage("0", _pageNoSup);
                  },
                  onLoading: () {
                    _pageNoSup += 1;
                    queryCustomerPage("0", _pageNoSup);
                  },
                  child: ListView.builder(
                    itemBuilder: (c, i) => _buildItem(c, _supList[i], 0),
                    itemExtent: 80,
                    itemCount: _supList.length,
                  ),
                ))
              ],
            ),
            Column(
              children: [
                Container(
                  height: 45,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5),
                    border: Border.all(
                        color: ColorUtil.edit_box_gray, width: 1), //边框
                  ),
                  margin: const EdgeInsets.all(5),
                  child: TextField(
                      controller: _customerEditController,
                      decoration: InputDecoration(
                          isCollapsed: true,
                          contentPadding: EdgeInsets.all(8),
                          hintText: "客户名称",
                          hintStyle: TextStyle(
                              color: ColorUtil.GRAY_9,
                              fontSize: FontSizeUtil.BIG),
                          border: const OutlineInputBorder(
                              borderSide: BorderSide.none),
                          suffixIcon: RaisedButton(
                            onPressed: () {
                              _pageNoCustomer = 1;
                              queryCustomerPage("2", _pageNoCustomer);
                            },
                            color: ColorUtil.BLUE,
                            textColor: ColorUtil.White,
                            child: const Text("搜索"),
                          ))),
                ),
                Expanded(
                    child: SmartRefresher(
                  controller: _refreshCustomerController,
                  enablePullDown: true,
                  enablePullUp: true,
                  onRefresh: () {
                    _pageNoCustomer = 1;
                    queryCustomerPage("2", _pageNoCustomer);
                  },
                  onLoading: () {
                    _pageNoCustomer += 1;
                    queryCustomerPage("2", _pageNoCustomer);
                  },
                  child: ListView.builder(
                    itemBuilder: (c, i) => _buildItem(c, _customerList[i], 2),
                    itemExtent: 80,
                    itemCount: _customerList.length,
                  ),
                ))
              ],
            ),
            Column(
              children: [
                Container(
                  height: 45,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5),
                    border: Border.all(
                        color: ColorUtil.edit_box_gray, width: 1), //边框
                  ),
                  margin: const EdgeInsets.all(5),
                  child: TextField(
                      controller: _unitEditController,
                      decoration: InputDecoration(
                          isCollapsed: true,
                          contentPadding: EdgeInsets.all(8),
                          hintText: "往来单位名称",
                          hintStyle: TextStyle(
                              color: ColorUtil.GRAY_9,
                              fontSize: FontSizeUtil.BIG),
                          border: const OutlineInputBorder(
                              borderSide: BorderSide.none),
                          suffixIcon: RaisedButton(
                            onPressed: () {
                              _pageNoUnit = 1;
                              queryCustomerPage("3", _pageNoUnit);
                            },
                            color: ColorUtil.BLUE,
                            textColor: ColorUtil.White,
                            child: const Text("搜索"),
                          ))),
                ),
                Expanded(
                    child: SmartRefresher(
                  controller: _refreshUnitController,
                  enablePullUp: true,
                  onRefresh: () {
                    _pageNoUnit = 1;
                    queryCustomerPage("3", _pageNoUnit);
                  },
                  onLoading: () {
                    _pageNoUnit += 1;
                    queryCustomerPage("3", _pageNoUnit);
                  },
                  child: ListView.builder(
                    itemBuilder: (c, i) => _buildItem(c, _unitList[i], 3),
                    itemExtent: 80,
                    itemCount: _unitList.length,
                  ),
                ))
              ],
            ),
          ]),
    );
  }

  Widget _buildItem(BuildContext context, CustomerBean item, int customerType) {
    return Card(
        child: ListTile(
            onTap: () {
              //0.供应商 1.员工 2.客户 3.其他往来单位
              var sup = SupBean(supId: item.id, supType: customerType, supName: item.khNm);
              Navigator.of(context).pop(json.encode(sup));
            },
            title: Text(item.khNm!),
            subtitle: Text(item.linkman ?? ""),
            trailing: Text(item.mobile ?? ""),
        )
    );
  }

  final TextEditingController _supEditController = TextEditingController();
  final TextEditingController _customerEditController = TextEditingController();
  final TextEditingController _unitEditController = TextEditingController();

  final RefreshController _refreshCustomerController =
      RefreshController(initialRefresh: false);
  final RefreshController _refreshSupController =
      RefreshController(initialRefresh: false);
  final RefreshController _refreshUnitController =
      RefreshController(initialRefresh: false);
}
