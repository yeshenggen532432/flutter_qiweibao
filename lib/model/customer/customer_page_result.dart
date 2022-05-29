import 'package:flutterqiweibao/model/customer/customer_bean.dart';

class CustomerPageResult {
  int? code;
  String? message;
  Data? data;
  String? msg;
  bool? success;
  bool? state;

  CustomerPageResult(
      {this.code, this.message, this.data, this.msg, this.success, this.state});

  CustomerPageResult.fromJson(Map<String, dynamic> json) {
    code = json['code'];
    message = json['message'];
    data = json['data'] != null ? new Data.fromJson(json['data']) : null;
    msg = json['msg'];
    success = json['success'];
    state = json['state'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['code'] = this.code;
    data['message'] = this.message;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    data['msg'] = this.msg;
    data['success'] = this.success;
    data['state'] = this.state;
    return data;
  }
}

class Data {
  int? total;
  int? curPage;
  int? pageSize;
  int? totalPage;
  List<CustomerBean>? rows;

  Data(
      {this.total,
        this.curPage,
        this.pageSize,
        this.totalPage,
        this.rows});

  Data.fromJson(Map<String, dynamic> json) {
    total = json['total'];
    curPage = json['curPage'];
    pageSize = json['pageSize'];
    totalPage = json['totalPage'];
    if (json['rows'] != null) {
      rows = <CustomerBean>[];
      json['rows'].forEach((v) {
        rows!.add(new CustomerBean.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['total'] = this.total;
    data['curPage'] = this.curPage;
    data['pageSize'] = this.pageSize;
    data['totalPage'] = this.totalPage;
    if (this.rows != null) {
      data['rows'] = this.rows!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}
