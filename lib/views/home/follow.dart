import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import '../../conponents/feedItemCard.dart';
import '../../plugins/dio.dart' show $http;

class FollowFeedList extends StatefulWidget {
  FollowFeedList({Key key}) : super(key: key);
  @override
  _FollowFeedListState createState() => _FollowFeedListState();
}

class _FollowFeedListState extends State<FollowFeedList> {
  List list;
  Future getData() async {
    Response response = await $http.get(
        "major-service/major/v1/follow/post?timeline=0&count=6",
        queryParameters: {"timeline": 0, "count": 10});
    list = response.data['data']['list'];
  }

  @override
  void initState() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: getData(),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if ((snapshot.connectionState == ConnectionState.done)) {
            if (snapshot.hasError) {
              return Center(
                child: Text("Error: ${snapshot.error}"),
              );
            } else {
              return ListView.separated(
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
                      videoPoster:
                          "http://benyuan.besmile.me/${currentItem['addrVideoArr'][0]}?vframe/jpg/offset/2",
                      topicName: currentItem['topicName'],
                      type: currentItem['type'],
                      topicId: currentItem['topicId'],
                      digCount: currentItem['digCount'],
                      buryCount: currentItem['buryCount'],
                      shareCount: currentItem['shareCount'],
                      markCount: currentItem['markCount'],
                      commentCount: currentItem['commentCount'],
                      imageList: currentItem['imageList'],
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
                  }
                },
              );
            }
          } else {
            // 请求未结束，显示loading
            return Center(
              child: CircularProgressIndicator(),
            );
          }
        });
  }
}
