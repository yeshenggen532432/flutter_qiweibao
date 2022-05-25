class RouteBean {
  String? route;

  RouteBean({this.route});

  RouteBean.fromJson(Map<String, dynamic> json) {
    route = json['route'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['route'] = this.route;
    return data;
  }
}