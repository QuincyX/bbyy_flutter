/*
 * @Date: 2020-02-18 10:07:58
 * @LastEditors: Quincy
 * @LastEditTime: 2020-03-02 23:03:53
 * @Description: 帖子详情页
 */
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:by_flutter/views/common/error.dart';
import 'package:by_flutter/plugins/dio.dart' show $http;

class FeedDetailPage extends StatefulWidget {
  FeedDetailPage({Key key}) : super(key: key);
  @override
  _FeedDetailPageState createState() => _FeedDetailPageState();
}

class _FeedDetailPageState extends State<FeedDetailPage> {
  String _content;

  Future getDetailData(feedItemId) async {
    Response response =
        await $http.get('major-service/major/v1/post/detail/$feedItemId');
    _content = response.data['data']['content']?.toString();
  }

  @override
  Widget build(BuildContext context) {
    dynamic routerArguments = ModalRoute.of(context).settings.arguments;
    final feedItemId = routerArguments['id'];
    return FutureBuilder(
      future: getDetailData(feedItemId),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if ((snapshot.connectionState == ConnectionState.done)) {
          if (snapshot.hasError) {
            return CommonErrorPage(
              text: snapshot.error.toString(),
            );
          } else {
            return Scaffold(
              appBar: AppBar(
                title: Text("帖子详情"),
              ),
              body: Column(
                children: <Widget>[
                  Expanded(
                    child: Center(
                      child: Text("router params id: ${feedItemId.toString()}"),
                    ),
                  ),
                  Expanded(
                    child: Center(
                      child: Text(_content),
                    ),
                  ),
                ],
              ),
            );
          }
        } else {
          return Center(
            child: CircularProgressIndicator(),
          );
        }
      },
    );
  }
}
