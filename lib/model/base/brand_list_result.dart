import 'package:flutterqiweibao/model/base/brand_bean.dart';

class BrandListResult {
  int? code;
  String? message;
  List<BrandBean>? data;
  String? msg;
  bool? success;
  bool? state;

  BrandListResult(
      {this.code, this.message, this.data, this.msg, this.success, this.state});

  BrandListResult.fromJson(Map<String, dynamic> json) {
    code = json['code'];
    message = json['message'];
    if (json['data'] != null) {
      data = <BrandBean>[];
      json['data'].forEach((v) {
        data!.add(new BrandBean.fromJson(v));
      });
    }
    msg = json['msg'];
    success = json['success'];
    state = json['state'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['code'] = this.code;
    data['message'] = this.message;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    data['msg'] = this.msg;
    data['success'] = this.success;
    data['state'] = this.state;
    return data;
  }
}

