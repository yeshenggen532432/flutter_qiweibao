import 'package:flutterqiweibao/model/pic_bean.dart';

class WarePic {
  int? id;
  int? type;
  String? picMini;
  String? pic;
  int? wareId;
  int? sort;

  WarePic(
      {this.id, this.type, this.picMini, this.pic, this.wareId, this.sort});

  WarePic.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    type = json['type'];
    picMini = json['picMini'];
    pic = json['pic'];
    wareId = json['wareId'];
    sort = json['sort'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['type'] = this.type;
    data['picMini'] = this.picMini;
    data['pic'] = this.pic;
    data['wareId'] = this.wareId;
    data['sort'] = this.sort;
    return data;
  }

  WarePic.fromUploadPic(PicBean picBean) {
    picMini = picBean.objectId;
    pic = picBean.objectId;
  }

}