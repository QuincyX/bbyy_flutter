import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:by_flutter/conponents/feedItemCard.dart';
import 'package:by_flutter/plugins/dio.dart';
import 'package:by_flutter/models/user.dart';
import 'package:by_flutter/views/common/error.dart';
import 'package:by_flutter/views/common/loading.dart';

class RecommendsFeedList extends StatefulWidget {
  RecommendsFeedList({Key key}) : super(key: key);
  @override
  _RecommendsListState createState() => _RecommendsListState();
}

class _RecommendsListState extends State<RecommendsFeedList> {
  List list;
  Future getData() async {
    Response response = await $http.get(
      "major-service/post/v1/post/recommends",
      queryParameters: {"timeline": 0, "count": 10},
    );
    list = response.data['data']['list'];
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
            return ErrorMessagePage(
              text: snapshot.error.toString(),
            );
          } else {
            return Scaffold(
              appBar: AppBar(
                title: Text("广场"),
              ),
              body: Column(
                children: <Widget>[
                  Expanded(
                    child: Container(
                      child: ListView.separated(
                        shrinkWrap: true,
                        itemCount: 10,
                        separatorBuilder: (BuildContext context, int index) {
                          return Container(
                            height: 16,
                            decoration: BoxDecoration(
                              color: Colors.grey[200],
                            ),
                          );
                        },
                        itemBuilder: (BuildContext context, int index) {
                          var currentItem = list[index];
                          if (currentItem != null) {
                            return new FeedItemCard(
                              id: currentItem['id'].toString(),
                              content: currentItem['content'],
                              avInfo: currentItem['avInfo'],
                              topicName: currentItem['topicName'],
                              type: currentItem['type'],
                              topicId: currentItem['topicId'],
                              digCount: currentItem['digCount'],
                              buryCount: currentItem['buryCount'],
                              shareCount: currentItem['shareCount'],
                              markCount: currentItem['markCount'],
                              commentCount: currentItem['commentCount'],
                              imageList: currentItem['addrImgArr'],
                              isFollow: currentItem['isFollow'],
                              isMark: currentItem['isMark'],
                              isDig: currentItem['isDig'],
                              isBury: currentItem['isBury'],
                              user: User(
                                id: currentItem['user']['id'].toString(),
                                nickName: currentItem['user']['nickName'],
                                avatar: currentItem['user']['avatar'],
                              ),
                            );
                          } else {
                            return Container(
                              child: Text('feed content error'),
                            );
                          }
                        },
                      ),
                    ),
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
