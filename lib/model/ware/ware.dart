import 'package:flutterqiweibao/model/ware/ware_pic.dart';

class Ware {
  int? wareId;
  String? wareNm;
  int? waretype;
  String? packBarCode;
  String? beBarCode;
  String? wareDw;
  String? minUnit;
  String? wareGg;
  String? minWareGg;
  num? wareDj;
  num? sunitPrice;
  num? lsPrice;
  num? minLsPrice;
  num? inPrice;
  num? minInPrice;
  String? status;
  String? wareFeatures;
  int? businessType;
  num? sort;
  num? minSort;
  num? waretypeSort;
  int? bUnit;
  num? sUnit;
  num? hsNum;
  String? wareCode;
  String? py;
  String? waretypePath;
  int? isType;
  int? noCompany;
  String? unitName;
  int? brandId;
  num? salePrice;
  String? maxUnit;
  String? minUnitName;
  num? minSalePrice;
  int? supId;
  String? supName;
  int? supType;
  String? wareDesc;
  String? qualityDays;
  num? qualityAlert;
  int? sunitFront;
  int? inDefaultUnit;
  String? produceDate;
  String? remark;
  String? sortCode;
  String? minSortCode;
  num? innerAccPriceDefault;
  String? waretypeNm;
  String? brandNm;
  int? qualityUnit;
  num? warnQty;
  num? lowestSalePrice;
  List<WarePic>? warePicList;

  Ware(
      {this.wareId,
        this.wareNm,
        this.waretype,
        this.packBarCode,
        this.beBarCode,
        this.wareDw,
        this.minUnit,
        this.wareGg,
        this.minWareGg,
        this.wareDj,
        this.sunitPrice,
        this.lsPrice,
        this.minLsPrice,
        this.inPrice,
        this.minInPrice,
        this.status,
        this.wareFeatures,
        this.businessType,
        this.sort,
        this.minSort,
        this.waretypeSort,
        this.bUnit,
        this.sUnit,
        this.hsNum,
        this.wareCode,
        this.py,
        this.waretypePath,
        this.isType,
        this.noCompany,
        this.unitName,
        this.brandId,
        this.salePrice,
        this.maxUnit,
        this.minUnitName,
        this.minSalePrice,
        this.supId,
        this.supName,
        this.supType,
        this.wareDesc,
        this.qualityDays,
        this.qualityAlert,
        this.sunitFront,
        this.inDefaultUnit,
        this.produceDate,
        this.remark,
        this.sortCode,
        this.minSortCode,
        this.innerAccPriceDefault,
        this.waretypeNm,
        this.brandNm,
        this.qualityUnit,
        this.warnQty,
        this.lowestSalePrice,
        this.warePicList});

  Ware.fromJson(Map<String, dynamic> json) {
    wareId = json['wareId'];
    wareNm = json['wareNm'];
    waretype = json['waretype'];
    packBarCode = json['packBarCode'];
    beBarCode = json['beBarCode'];
    wareDw = json['wareDw'];
    minUnit = json['minUnit'];
    wareGg = json['wareGg'];
    minWareGg = json['minWareGg'];
    wareDj = json['wareDj'];
    sunitPrice = json['sunitPrice'];
    lsPrice = json['lsPrice'];
    minLsPrice = json['minLsPrice'];
    inPrice = json['inPrice'];
    minInPrice = json['minInPrice'];
    status = json['status'];
    wareFeatures = json['wareFeatures'];
    businessType = json['businessType'];
    sort = json['sort'];
    minSort = json['minSort'];
    waretypeSort = json['waretypeSort'];
    bUnit = json['bUnit'];
    sUnit = json['sUnit'];
    hsNum = json['hsNum'];
    wareCode = json['wareCode'];
    py = json['py'];
    waretypePath = json['waretypePath'];
    isType = json['isType'];
    noCompany = json['noCompany'];
    unitName = json['unitName'];
    brandId = json['brandId'];
    salePrice = json['salePrice'];
    maxUnit = json['maxUnit'];
    minUnitName = json['minUnitName'];
    minSalePrice = json['minSalePrice'];
    supId = json['supId'];
    supName = json['supName'];
    supType = json['supType'];
    wareDesc = json['wareDesc'];
    qualityDays = json['qualityDays'];
    qualityAlert = json['qualityAlert'];
    sunitFront = json['sunitFront'];
    inDefaultUnit = json['inDefaultUnit'];
    produceDate = json['produceDate'];
    remark = json['remark'];
    sortCode = json['sortCode'];
    minSortCode = json['minSortCode'];
    innerAccPriceDefault = json['innerAccPriceDefault'];
    waretypeNm = json['waretypeNm'];
    brandNm = json['brandNm'];
    qualityUnit = json['qualityUnit'];
    warnQty = json['warnQty'];
    lowestSalePrice = json['lowestSalePrice'];
    if (json['warePicList'] != null) {
      warePicList = [];
      json['warePicList'].forEach((v) {
        warePicList!.add(new WarePic.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['wareId'] = this.wareId;
    data['wareNm'] = this.wareNm;
    data['waretype'] = this.waretype;
    data['packBarCode'] = this.packBarCode;
    data['beBarCode'] = this.beBarCode;
    data['wareDw'] = this.wareDw;
    data['minUnit'] = this.minUnit;
    data['wareGg'] = this.wareGg;
    data['minWareGg'] = this.minWareGg;
    data['wareDj'] = this.wareDj;
    data['sunitPrice'] = this.sunitPrice;
    data['lsPrice'] = this.lsPrice;
    data['minLsPrice'] = this.minLsPrice;
    data['inPrice'] = this.inPrice;
    data['minInPrice'] = this.minInPrice;
    data['status'] = this.status;
    data['wareFeatures'] = this.wareFeatures;
    data['businessType'] = this.businessType;
    data['sort'] = this.sort;
    data['minSort'] = this.minSort;
    data['waretypeSort'] = this.waretypeSort;
    data['bUnit'] = this.bUnit;
    data['sUnit'] = this.sUnit;
    data['hsNum'] = this.hsNum;
    data['wareCode'] = this.wareCode;
    data['py'] = this.py;
    data['waretypePath'] = this.waretypePath;
    data['isType'] = this.isType;
    data['noCompany'] = this.noCompany;
    data['unitName'] = this.unitName;
    data['brandId'] = this.brandId;
    data['salePrice'] = this.salePrice;
    data['maxUnit'] = this.maxUnit;
    data['minUnitName'] = this.minUnitName;
    data['minSalePrice'] = this.minSalePrice;
    data['supId'] = this.supId;
    data['supName'] = this.supName;
    data['supType'] = this.supType;
    data['wareDesc'] = this.wareDesc;
    data['qualityDays'] = this.qualityDays;
    data['qualityAlert'] = this.qualityAlert;
    data['sunitFront'] = this.sunitFront;
    data['inDefaultUnit'] = this.inDefaultUnit;
    data['produceDate'] = this.produceDate;
    data['remark'] = this.remark;
    data['sortCode'] = this.sortCode;
    data['minSortCode'] = this.minSortCode;
    data['innerAccPriceDefault'] = this.innerAccPriceDefault;
    data['waretypeNm'] = this.waretypeNm;
    data['brandNm'] = this.brandNm;
    data['qualityUnit'] = this.qualityUnit;
    data['warnQty'] = this.warnQty;
    data['lowestSalePrice'] = this.lowestSalePrice;
    if (this.warePicList != null) {
      data['warePicList'] = this.warePicList!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}