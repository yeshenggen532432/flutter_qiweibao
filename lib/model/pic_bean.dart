
class PicBean {
  String? name;
  String? bucket;
  String? origin;
  int? size;
  String? url;
  String? domain;
  String? ext;
  String? mime;
  String objectId = "";

  PicBean(
      {this.name,
        this.bucket,
        this.origin,
        this.size,
        this.url,
        this.domain,
        this.ext,
        this.mime,
        required this.objectId});

  PicBean.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    bucket = json['bucket'];
    origin = json['origin'];
    size = json['size'];
    url = json['url'];
    domain = json['domain'];
    ext = json['ext'];
    mime = json['mime'];
    objectId = json['objectId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    data['bucket'] = this.bucket;
    data['origin'] = this.origin;
    data['size'] = this.size;
    data['url'] = this.url;
    data['domain'] = this.domain;
    data['ext'] = this.ext;
    data['mime'] = this.mime;
    data['objectId'] = this.objectId;
    return data;
  }
}