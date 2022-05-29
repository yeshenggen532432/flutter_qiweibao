class BrandBean {
  int? id;
  String? name;
  int? status;
  String? remark;
  int? vendorId;
  int? vendorType;
  String? vendorName;

  BrandBean(
      {this.id,
        this.name,
        this.status,
        this.remark,
        this.vendorId,
        this.vendorType,
        this.vendorName});

  BrandBean.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    status = json['status'];
    remark = json['remark'];
    vendorId = json['vendorId'];
    vendorType = json['vendorType'];
    vendorName = json['vendorName'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['status'] = this.status;
    data['remark'] = this.remark;
    data['vendorId'] = this.vendorId;
    data['vendorType'] = this.vendorType;
    data['vendorName'] = this.vendorName;
    return data;
  }
}