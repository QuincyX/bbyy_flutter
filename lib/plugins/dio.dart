import 'package:dio/dio.dart';
import 'dart:async';
import '../store/global.dart';

Dio $http = Dio(
  BaseOptions(
    baseUrl: "http://api.besmile.me/",
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
    //   return ResponseWithList(
    //     list: response.data['data']['list'],
    //     page: ResponsePage(
    //       timeline: response.data['data']['timeline'],
    //     ),
    //   );
    // } else {
    //   return response.data['data']['data'];
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

class ResponseWithList {
  ResponseWithList({this.list, this.page});
  List list;
  ResponsePage page;
}

class ResponsePage {
  ResponsePage({this.timeline});
  int timeline;
}
