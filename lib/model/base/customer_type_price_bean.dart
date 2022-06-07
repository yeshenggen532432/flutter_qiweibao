class CustomerTypePriceBean {
  int? id;
  int? customerTypeId;
  String? customerTypeName;
  num? salePrice;
  num? minSalePrice;

  CustomerTypePriceBean(
      {this.customerTypeId,
        this.customerTypeName,
        this.salePrice,
        this.minSalePrice});

  CustomerTypePriceBean.fromJson(Map<String, dynamic> json) {
    customerTypeId = json['customerTypeId'];
    customerTypeName = json['customerTypeName'];
    salePrice = json['salePrice'];
    minSalePrice = json['minSalePrice'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['customerTypeId'] = this.customerTypeId;
    data['customerTypeName'] = this.customerTypeName;
    data['salePrice'] = this.salePrice;
    data['minSalePrice'] = this.minSalePrice;
    return data;
  }
}