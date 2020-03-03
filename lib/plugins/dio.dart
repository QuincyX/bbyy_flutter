/*
 * @Date: 2020-02-14 17:36:49
 * @LastEditors: Quincy
 * @LastEditTime: 2020-03-02 20:46:08
 * @Description: http request adapter
 */
import 'package:dio/dio.dart';
import 'dart:async';
import '../store/global.dart';

Dio $http = Dio(
  BaseOptions(
    baseUrl: "http://api.besmile.me/h5-gw/",
    connectTimeout: 5000,
    receiveTimeout: 3000,
    responseType: ResponseType.json,
  ),
);

void initHttpInstance() {
  $http.interceptors.add(CommonInterceptor());
}

class CommonInterceptor extends InterceptorsWrapper {
  @override
  Future onRequest(RequestOptions options) async {
    if (Global.jwtToken != null) {
      options.headers['jwt-token'] = Global.jwtToken;
      // print(">>>>>> request token: ${options.headers['jwt-token']}");
    }
    return super.onRequest(options);
  }

  @override
  Future onResponse(Response response) async {
    print(
        ">>>>>> success [${response?.statusCode}] => PATH: ${response?.request?.path}");
    if (response.headers['jwt-token'] != null) {
      Global.setJwtToken(response.headers['jwt-token'][0]);
    }
    // if (response.data['data']['list'] != null) {
    //   response.extra['list'] = response.data['data']['list'];
    //   response.extra['page'] = {
    //     "timeline": response.data['data']['timeline'],
    //     "count": response.data['data']['count'],
    //     // "finish": (response.data['data']['hasNext'] == '1') ? true : false,
    //   };
    // }
    // if (response.data['data']['data'] != null) {
    //   response.extra['data'] = response.data['data']['data'];
    // }
    return super.onResponse(response);
  }

  @override
  Future onError(DioError e) async {
    print(
        ">>>>>> error [${e.response?.statusCode}] => PATH: ${e.response?.request?.path}");
    if (e.response?.statusCode == 401) {
      print("token expired or token error !");
    }
    return e; //continue
  }
}

class ResponseList {
  ResponseList({this.list, this.page});
  List list;
  ResponsePage page;
}

class ResponsePage {
  ResponsePage({this.timeline, this.count, this.finish});
  int timeline;
  int count;
  bool finish;
}

class ResponseData {
  ResponseData();
}
