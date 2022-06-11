import 'package:flutterqiweibao/utils/http/http_manager.dart';
import 'package:flutterqiweibao/utils/http/url_manager.dart';

class ApiManager{
  ///通用全局单例，第一次使用时初始化
  static ApiManager _instance = ApiManager._internal();
  factory ApiManager() => _instance;
  ApiManager._internal() {
  }

  static ApiManager getInstance() {
    return _instance;
  }

  Future<Map<String, dynamic>> getWareTypeTree(Map<String, dynamic>? params) async {
    Map<String, dynamic> map = await HttpManager.getInstance().get(UrlManager.WARE_TYPE_TREE, params:params);
    return map;
  }




}



