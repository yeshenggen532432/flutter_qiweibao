class SupBean {
  int? supId;
  String? supName;
  int? supType;
  SupBean(
      {
        this.supId,
        this.supName,
        this.supType});

  SupBean.fromJson(Map<String, dynamic> json) {
    supId = json['supId'];
    supName = json['supName'];
    supType = json['supType'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['supId'] = this.supId;
    data['supName'] = this.supName;
    data['supType'] = this.supType;
    return data;
  }
}