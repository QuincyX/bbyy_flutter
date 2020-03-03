import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

import 'package:by_flutter/plugins/dio.dart' show $http;
import 'package:by_flutter/views/common/loading.dart';
import 'package:by_flutter/views/common/navigationBar.dart';

class FeedListHomePage extends StatefulWidget {
  FeedListHomePage({Key key, this.title}) : super(key: key);
  final String title;
  @override
  _State createState() => _State();
}

class _State extends State<FeedListHomePage>
    with SingleTickerProviderStateMixin {
  Future getData() async {
    Response response = await $http.get(
      "major-service/post/v1/post/recommends",
      queryParameters: {"timeline": 0, "count": 10},
    );
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: getData(),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if ((snapshot.connectionState != ConnectionState.done)) {
          return CommonLoadingPage(text: "加载中...");
        } else {
          if (snapshot.hasError) {
            return Scaffold(
              body: Center(
                child: Text("Error: ${snapshot.error}"),
              ),
            );
          } else {
            return Scaffold(
              appBar: AppBar(
                title: Text(widget.title),
              ),
              bottomNavigationBar: NavigationBar(),
              body: Column(
                children: <Widget>[
                  Container(
                    child: Text("feed card"),
                  ),
                  Container(
                    child: Row(children: []),
                  ),
                ],
              ),
            );
          }
        }
      },
    );
  }

  void showMessageDialog(BuildContext context) {
    showDialog(
        context: context,
        builder: (context) {
          return new SimpleDialog(
            title: new Text("提示"),
            children: <Widget>[
              new SimpleDialogOption(
                child: new Text("这是一条提示消息"),
              ),
            ],
          );
        });
  }
}
