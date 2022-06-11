import 'dart:math';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutterqiweibao/model/base_result.dart';
import 'package:flutterqiweibao/utils/contains_util.dart';
import '../loading_dialog_util.dart';
import 'package:flutterqiweibao/utils/http/url_manager.dart';
import 'package:flutterqiweibao/utils/toast_util.dart';

class HttpManager{
  ///通用全局单例，第一次使用时初始化
  static HttpManager _instance = HttpManager._internal();
  factory HttpManager() => _instance;
  Dio? _dio;
  HttpManager._internal() {
    if (null == _dio) {
      _dio = Dio(BaseOptions(
//          baseUrl: UrlManager.ROOT,
          headers: {"token": ContainsUtil.token},
          receiveTimeout: 30000,
          connectTimeout: 30000)
      );
//      _dio!.interceptors.add(LogInterceptor());
//      _dio.interceptors.add(new ResponseInterceptors());
    }
  }

  static HttpManager getInstance() {
    return _instance;
  }

  /**
   * 通用的GET请求
   * 备注使用时不要少了：await；不然会报错：type 'Future<dynamic>' is not a subtype of type 'Map<String, dynamic>'
      Map<String, dynamic> map = await HttpManager.getInstance().get(UrlManager.WARE_TYPE_TREE, params:params);
   */
  get(api, {params, withLoading = true}) async {
    if (withLoading) {
      LoadingDialogUtil.show();
    }

    Response response;
    try {
      response = await _dio!.get(UrlManager.ROOT + api, queryParameters: params);
    } on DioError catch (e) {
      return resultError(e).toJson();
    }finally{
      if (withLoading) {
        LoadingDialogUtil.dismiss();
      }
    }
    //这边可以写错误提示
//    if (response.data is DioError) {
//      return resultError(response.data['code']);
//    }
    return response.data;
  }


  //通用的POST请求
  post(api, {data, params, withLoading = true}) async {
    if (withLoading) {
      LoadingDialogUtil.show();
    }

    Response response;
    try {
      if(data){
        response = await _dio!.post(api, data: data);
      }else if(params){
        response = await _dio!.post(api, queryParameters: params);
      }else{
        response = await _dio!.post(api);
      }
    } on DioError catch (e) {
      return resultError(e).toJson();
    }finally{
      if (withLoading) {
        LoadingDialogUtil.dismiss();
      }
    }
    return response.data;
  }

  BaseResult resultError(DioError e) {
    Response errorResponse = e.response!;
    //网络超时
    if (e.type == DioErrorType.connectTimeout || e.type == DioErrorType.receiveTimeout) {
      errorResponse.statusMessage = "网络请求超时";
    }
    return  BaseResult(message:errorResponse.statusMessage, msg:errorResponse.statusMessage, success:false, state:false);
  }


}



