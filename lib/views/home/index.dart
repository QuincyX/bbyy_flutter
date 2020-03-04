import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'package:by_flutter/plugins/dio.dart' show $http;
import 'package:by_flutter/views/common/loading.dart';
import 'package:by_flutter/views/common/error.dart';
import 'package:by_flutter/components/navigationBar.dart';

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
      queryParameters: {"timeline": 0, "count": 5},
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
            return CommonErrorPage(
              text: snapshot.error.toString(),
            );
          } else {
            return Scaffold(
              appBar: AppBar(
                title: Text(widget.title),
              ),
              bottomNavigationBar: NavigationBar(),
              body: Column(
                children: <Widget>[
                  Expanded(
                    flex: 3,
                    child: _cardContainer(),
                  ),
                  Expanded(
                    flex: 1,
                    child: _actionBar(),
                  ),
                ],
              ),
            );
          }
        }
      },
    );
  }
}

Widget _cardContainer() {
  return Container(
    padding: EdgeInsets.all(20.0),
    child: Stack(
      children: <Widget>[
        _buildBackground(),
        Positioned(
          left: 10.0,
          top: 20.0,
          bottom: 40.0,
          right: 10.0,
          child: Card(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisSize: MainAxisSize.max,
              children: <Widget>[
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.red[200],
                    ),
                    child: Center(
                      child: Text(
                        "Beauty image",
                        style: TextStyle(
                          fontSize: 40,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ),
                Container(
                  padding: EdgeInsets.all(15),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: <Widget>[
                      Container(
                        margin: EdgeInsets.only(bottom: 15),
                        child: Text(
                          "Pretty girl",
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.black,
                          ),
                        ),
                      ),
                      Container(
                        child: Text(
                          "And I love you so",
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.blueGrey,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    ),
  );
}

Stack _buildBackground() {
  return Stack(
    children: <Widget>[
      Positioned(
        child: Card(
          child: Text('background 1'),
        ),
        left: 40.0,
        top: 40.0,
        bottom: 10.0,
        right: 40.0,
      ),
      Positioned(
        child: Card(
          child: Text('background 2'),
        ),
        left: 30.0,
        top: 30.0,
        bottom: 20.0,
        right: 30.0,
      ),
      Positioned(
        child: Card(
          child: Text('background 3'),
        ),
        left: 20.0,
        top: 30.0,
        bottom: 30.0,
        right: 20.0,
      ),
    ],
  );
}

Widget _actionBar() {
  return Row(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      GestureDetector(
        onTap: () {
          _toast("Sorry, I don't like this girl");
        },
        child: Container(
          padding: EdgeInsets.all(15),
          margin: EdgeInsets.all(20),
          decoration: BoxDecoration(
            border: Border.all(
              width: 2,
              color: Colors.amber[800],
            ),
            borderRadius: BorderRadius.circular(50),
            color: Colors.white,
          ),
          child: Icon(
            Icons.clear,
            size: 35,
            color: Colors.amber[800],
          ),
        ),
      ),
      GestureDetector(
        onTap: () {
          _toast("Hooray! I like this girl");
        },
        child: Container(
          padding: EdgeInsets.all(15),
          margin: EdgeInsets.all(20),
          decoration: BoxDecoration(
            border: Border.all(
              width: 2,
              color: Colors.amber[800],
            ),
            borderRadius: BorderRadius.circular(50),
            color: Colors.amber[800],
          ),
          child: Icon(
            Icons.favorite_border,
            size: 35,
            color: Colors.white,
          ),
        ),
      ),
    ],
  );
}

void _toast(String text) {
  Fluttertoast.showToast(
    msg: text,
    toastLength: Toast.LENGTH_SHORT,
    gravity: ToastGravity.CENTER,
    timeInSecForIos: 1,
    backgroundColor: Colors.amber[800],
    textColor: Colors.white,
    fontSize: 16.0,
  );
}
