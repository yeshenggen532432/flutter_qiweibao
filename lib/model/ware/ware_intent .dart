class WareIntent {
  bool? add;
  int? wareId;

  WareIntent({this.add, this.wareId});

  WareIntent.fromJson(Map<String, dynamic> json) {
    add = json['add'];
    wareId = json['wareId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['add'] = this.add;
    data['wareId'] = this.wareId;
    return data;
  }
}