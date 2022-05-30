import 'package:flutterqiweibao/model/base/menu_bean.dart';

class MenuResult {
  String? msg;
  List<MenuBean>? applyList;
  bool? state;

  MenuResult({this.msg, this.applyList, this.state});

  MenuResult.fromJson(Map<String, dynamic> json) {
    msg = json['msg'];
    if (json['applyList'] != null) {
      applyList = <MenuBean>[];
      json['applyList'].forEach((v) {
        applyList!.add(new MenuBean.fromJson(v));
      });
    }
    state = json['state'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['msg'] = this.msg;
    if (this.applyList != null) {
      data['applyList'] = this.applyList!.map((v) => v.toJson()).toList();
    }
    data['state'] = this.state;
    return data;
  }
}



