import 'package:flutterqiweibao/model/ware/ware.dart';

class WareResult {
  bool? state;
  Ware? sysWare;

  WareResult({this.state, this.sysWare});

  WareResult.fromJson(Map<String, dynamic> json) {
    state = json['state'];
    sysWare =
    json['sysWare'] != null ? new Ware.fromJson(json['sysWare']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['state'] = this.state;
    if (this.sysWare != null) {
      data['sysWare'] = this.sysWare!.toJson();
    }
    return data;
  }
}


