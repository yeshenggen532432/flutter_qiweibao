class BaseResult {
  int? code;
  String? message;
  String? msg;
  bool? success;
  bool? state;

  BaseResult({this.code, this.message, this.msg, this.success, this.state});

  BaseResult.fromJson(Map<String, dynamic> json) {
    code = json['code'];
    message = json['message'];
    msg = json['msg'];
    success = json['success'];
    state = json['state'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['code'] = this.code;
    data['message'] = this.message;
    data['msg'] = this.msg;
    data['success'] = this.success;
    data['state'] = this.state;
    return data;
  }
}