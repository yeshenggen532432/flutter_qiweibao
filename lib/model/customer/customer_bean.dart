class CustomerBean {
  int? id;
  String? khNm;
  String? xxzt;
  int? locationTag;
  int? customerType;
  String? linkman;
  String? mobile;
  String? tel;
  String? province;
  String? city;
  String? area;
  String? address;
  String? longitude;
  String? latitude;

  CustomerBean(
      {this.id,
        this.khNm,
        this.xxzt,
        this.locationTag,
        this.customerType,
        this.linkman,
        this.mobile,
        this.tel,
        this.province,
        this.city,
        this.area,
        this.address,
        this.longitude,
        this.latitude});

  CustomerBean.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    khNm = json['khNm'];
    xxzt = json['xxzt'];
    locationTag = json['locationTag'];
    customerType = json['customerType'];
    linkman = json['linkman'];
    mobile = json['mobile'];
    tel = json['tel'];
    province = json['province'];
    city = json['city'];
    area = json['area'];
    address = json['address'];
    longitude = json['longitude'];
    latitude = json['latitude'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['khNm'] = this.khNm;
    data['xxzt'] = this.xxzt;
    data['locationTag'] = this.locationTag;
    data['customerType'] = this.customerType;
    data['linkman'] = this.linkman;
    data['mobile'] = this.mobile;
    data['tel'] = this.tel;
    data['province'] = this.province;
    data['city'] = this.city;
    data['area'] = this.area;
    data['address'] = this.address;
    data['longitude'] = this.longitude;
    data['latitude'] = this.latitude;
    return data;
  }
}