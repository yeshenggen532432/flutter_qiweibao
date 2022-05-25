class RouteBean {
  String? route;
  bool?  type;
  int? wareId;

  RouteBean({this.route, this.type, this.wareId});

  RouteBean.fromJson(Map<String, dynamic> json) {
    route = json['route'];
    type = json['type'];
    wareId = json['wareId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['route'] = this.route;
    data['type'] = this.type;
    data['wareId'] = this.wareId;
    return data;
  }
}