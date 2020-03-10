import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'package:by_flutter/plugins/dio.dart' show $http;
import 'package:by_flutter/views/common/loading.dart';
import 'package:by_flutter/views/common/error.dart';
import 'package:by_flutter/components/navigationBar.dart';
import 'package:by_flutter/components/slideStack.dart';

class FeedItem {
  final String cover;
  final String video;
  final String name;
  final String bio;
  final String id;

  FeedItem({this.cover, this.video, this.name, this.bio, this.id});
}

class FeedListHomePage extends StatefulWidget {
  FeedListHomePage({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _State createState() => _State();
}

class _State extends State<FeedListHomePage>
    with SingleTickerProviderStateMixin {
  AnimationController controller;
  List<FeedItem> list = [];
  int aboveIndex = 0;
  int belowIndex = 1;
  final double bottomHeight = 100.0;
  final double defaultIconSize = 30.0;
  final Color defaultIconColor =
      Color.lerp(Color(0xFFFF80AB), Color(0xFFC51162), 0.0);

  double position = 0.0;
  SlideDirection slideDirection;

  double get leftIconSize => slideDirection == SlideDirection.left
      ? defaultIconSize * (1 + position * 0.8)
      : defaultIconSize;

  double get rightIconSize => slideDirection == SlideDirection.right
      ? defaultIconSize * (1 + position * 0.8)
      : defaultIconSize;

  Color get leftIconColor => slideDirection == SlideDirection.left
      ? Color.lerp(Color(0xFFFF80AB), Color(0xFFC51162), position)
      : defaultIconColor;

  Color get rightIconColor => slideDirection == SlideDirection.right
      ? Color.lerp(Color(0xFFFF80AB), Color(0xFFC51162), position)
      : defaultIconColor;

  Future getData() async {
    Response response = await $http.get(
      "major-service/post/v1/post/recommends",
      queryParameters: {"timeline": 0, "count": 5},
    );
    // list = response.data['data']['list'];
  }

  void setAboveIndex() {
    if (aboveIndex < list.length - 1) {
      aboveIndex++;
    } else {
      aboveIndex = 0;
    }
  }

  void setBelowIndex() {
    if (belowIndex < list.length - 1) {
      belowIndex++;
    } else {
      belowIndex = 0;
    }
  }

  void onSlide(double position, SlideDirection direction) {
    setState(() {
      this.position = position;
      this.slideDirection = direction;
    });
  }

  void onSlideCompleted() {
    controller.forward();
    String isLike =
        (slideDirection == SlideDirection.left) ? 'dislike' : 'like';
    _toast('You $isLike this !');
    setAboveIndex();
  }

  @override
  void initState() {
    super.initState();
    list = [
      FeedItem(
        cover:
            "http://benyuan.besmile.me/2715cc8dbf0c476bba1ff6b2d9377e15?vframe/jpg/offset/3",
        video: "http://benyuan.besmile.me/2715cc8dbf0c476bba1ff6b2d9377e15",
        name: "Girl No.1",
        bio: "勇争第一",
        id: "1",
      ),
      FeedItem(
        cover:
            "http://benyuan.besmile.me/Fle2jHadDlIiDwLOfbcXYC8U3Q_O?vframe/jpg/offset/3",
        video: "http://benyuan.besmile.me/Fle2jHadDlIiDwLOfbcXYC8U3Q_O",
        name: "Girl No.2",
        bio: "中二青年",
        id: "2",
      ),
      FeedItem(
        cover:
            "http://benyuan.besmile.me/llcbhk-BHNzBXcPugLjla-l3F48-?vframe/jpg/offset/3",
        video: "http://benyuan.besmile.me/llcbhk-BHNzBXcPugLjla-l3F48-",
        name: "Girl No.3",
        bio: "三流砥柱",
        id: "3",
      ),
      FeedItem(
        cover:
            "http://benyuan.besmile.me/db60d4652c32456b885d0c4b1b06c8d0?vframe/jpg/offset/3",
        video: "http://benyuan.besmile.me/db60d4652c32456b885d0c4b1b06c8d0",
        name: "Girl No.4",
        bio: "四大皆空",
        id: "4",
      ),
    ];
    controller = new AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 250),
    )
      ..addListener(() {
        setState(() {
          if (position != 0) {
            position = 1 - controller.value;
          }
        });
      })
      ..addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          controller.reset();
        }
      });
  }

  @override
  void dispose() {
    super.dispose();
    controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
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

  Widget _cardContainer() {
    return Container(
      padding: EdgeInsets.all(20.0),
      child: Stack(
        children: <Widget>[
          _slideCardBackground(),
          Positioned(
            left: 10.0,
            top: 20.0,
            bottom: 40.0,
            right: 10.0,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisSize: MainAxisSize.max,
              children: <Widget>[
                Expanded(
                  child: SlideStack(
                    upper: _slideCard(list[aboveIndex]),
                    under: _slideCard(list[belowIndex]),
                    slideDistance: MediaQuery.of(context).size.width - 40.0,
                    onSlide: onSlide,
                    onSlideCompleted: onSlideCompleted,
                    refreshBelow: setBelowIndex,
                    rotateRate: 0.4,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _slideCard(FeedItem feedItem) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        Expanded(
          child: Container(
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(
                  width: 1.0,
                  color: Colors.grey[300],
                ),
              ),
            ),
            child: Image.network(
              feedItem.cover,
              fit: BoxFit.cover,
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
                  feedItem.name,
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.black,
                  ),
                ),
              ),
              Container(
                child: Text(
                  feedItem.bio,
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
    );
  }

  Stack _slideCardBackground() {
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
              borderRadius: BorderRadius.circular(50),
              color: Colors.white,
            ),
            child: Icon(
              Icons.clear,
              size: leftIconSize,
              color: leftIconColor,
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
              borderRadius: BorderRadius.circular(50),
              color: Colors.white,
            ),
            child: Icon(
              Icons.favorite_border,
              size: rightIconSize,
              color: rightIconColor,
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
      textColor: Colors.amber[800],
      backgroundColor: Colors.white,
      fontSize: 16.0,
    );
  }
}
