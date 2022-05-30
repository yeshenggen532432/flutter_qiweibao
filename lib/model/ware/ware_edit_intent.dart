class WareEditIntent {
  bool? add;
  int? wareId;
  String? token;
  String? baseUrl;

  WareEditIntent({this.add, this.wareId, required this.token, required this.baseUrl});

  WareEditIntent.fromJson(Map<String, dynamic> json) {
    add = json['add'];
    wareId = json['wareId'];
    token = json['token'];
    baseUrl = json['baseUrl'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['add'] = this.add;
    data['wareId'] = this.wareId;
    data['token'] = this.token;
    data['baseUrl'] = this.baseUrl;
    return data;
  }
}