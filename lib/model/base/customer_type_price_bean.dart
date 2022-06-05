class CustomerTypePriceBean {
  int? customerTypeId;
  String? customerTypeName;
  num? maxPrice;
  num? minPrice;

  CustomerTypePriceBean(
      {this.customerTypeId,
        this.customerTypeName,
        this.maxPrice,
        this.minPrice});

  CustomerTypePriceBean.fromJson(Map<String, dynamic> json) {
    customerTypeId = json['customerTypeId'];
    customerTypeName = json['customerTypeName'];
    maxPrice = json['maxPrice'];
    minPrice = json['minPrice'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['customerTypeId'] = this.customerTypeId;
    data['customerTypeName'] = this.customerTypeName;
    data['maxPrice'] = this.maxPrice;
    data['minPrice'] = this.minPrice;
    return data;
  }
}