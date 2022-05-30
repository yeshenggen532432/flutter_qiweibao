

class MenuBean {
  String? applyName;
  String? applyCode;
  String? applyIcon;
  String? applyUrl;
  List<MenuBean>? children;

  MenuBean(
      {
        this.applyName,
        this.applyCode,
        this.applyIcon,
        this.applyUrl,
        this.children,
        });

  MenuBean.fromJson(Map<String, dynamic> json) {
    applyName = json['applyName'];
    applyCode = json['applyCode'];
    applyIcon = json['applyIcon'];
    applyUrl = json['applyUrl'];
    if (json['children'] != null) {
      children = <MenuBean>[];
      json['children'].forEach((v) {
        children!.add(new MenuBean.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['applyName'] = this.applyName;
    data['applyCode'] = this.applyCode;
    data['applyIcon'] = this.applyIcon;
    data['applyUrl'] = this.applyUrl;
    if (this.children != null) {
      data['children'] = this.children!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

