import 'package:flutterqiweibao/model/base/customer_type_price_bean.dart';

class CustomerTypePriceResult {
  int? code;
  String? message;
  List<CustomerTypePriceBean>? data;
  String? msg;
  bool? state;
  bool? success;

  CustomerTypePriceResult(
      {this.code, this.message, this.data, this.msg, this.state, this.success});

  CustomerTypePriceResult.fromJson(Map<String, dynamic> json) {
    code = json['code'];
    message = json['message'];
    if (json['data'] != null) {
      data = [];
      json['data'].forEach((v) {
        data!.add(new CustomerTypePriceBean.fromJson(v));
      });
    }
    msg = json['msg'];
    state = json['state'];
    success = json['success'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['code'] = this.code;
    data['message'] = this.message;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    data['msg'] = this.msg;
    data['state'] = this.state;
    data['success'] = this.success;
    return data;
  }
}
