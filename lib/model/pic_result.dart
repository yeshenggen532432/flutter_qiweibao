import 'package:flutterqiweibao/model/pic_bean.dart';

class PicResult {
  int? code;
  String? message;
  PicBean data = PicBean(objectId: "");
  bool? state;
  bool? success;
  String? msg;

  PicResult(
      {this.code, this.message, required this.data, this.state, this.success, this.msg});

  PicResult.fromJson(Map<String, dynamic> json) {
    code = json['code'];
    message = json['message'];
    if(json['data'] != null){
      data = PicBean.fromJson(json['data']);
    }
    state = json['state'];
    success = json['success'];
    msg = json['msg'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['code'] = code;
    data['message'] = message;
    if (this.data != null) {
      data['data'] = this.data.toJson();
    }
    data['state'] = state;
    data['success'] = success;
    data['msg'] = msg;
    return data;
  }
}