/*
 * @Date: 2020-02-18 10:07:58
 * @LastEditors: Quincy
 * @LastEditTime: 2020-03-04 09:56:32
 * @Description: 帖子详情页
 */
import 'package:dio/dio.dart';
import 'package:by_flutter/plugins/dio.dart' show $http;
import 'package:flutter/material.dart';

import 'package:by_flutter/components/navigationBar.dart';
import 'package:by_flutter/components/feedItemCard.dart';
import 'package:by_flutter/views/common/error.dart';
import 'package:by_flutter/views/common/loading.dart';
import 'package:by_flutter/models/user.dart';

class ProfileHomePage extends StatefulWidget {
  ProfileHomePage({Key key}) : super(key: key);
  @override
  _State createState() => _State();
}

class _State extends State<ProfileHomePage> {
  Map _content;

  Future getData() async {
    Response response =
        await $http.get('major-service/post/v1/post/27398684861792256');
    var data = response.data['data'];
    print(data);
    _content = data;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: getData(),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if ((snapshot.connectionState != ConnectionState.done)) {
          return CommonLoadingPage();
        } else {
          if (snapshot.hasError) {
            return CommonErrorPage(
              text: snapshot.error.toString(),
            );
          } else {
            return Scaffold(
              appBar: AppBar(
                title: Text("帖子详情"),
              ),
              bottomNavigationBar: NavigationBar(
                currentIndex: 3,
              ),
              body: Column(
                children: <Widget>[
                  Expanded(
                    child: FeedItemCard(
                      id: _content['id'].toString(),
                      content: _content['content'],
                      avInfo: _content['avInfo'],
                      topicName: _content['topicName'],
                      type: _content['type'],
                      topicId: _content['topicId'],
                      digCount: _content['digCount'],
                      buryCount: _content['buryCount'],
                      shareCount: _content['shareCount'],
                      markCount: _content['markCount'],
                      commentCount: _content['commentCount'],
                      imageList: _content['addrImgArr'],
                      isFollow: _content['isFollow'],
                      isMark: _content['isMark'],
                      isDig: _content['isDig'],
                      isBury: _content['isBury'],
                      user: User(
                        id: _content['user']['id'].toString(),
                        nickName: _content['user']['nickName'],
                        avatar: _content['user']['avatar'],
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
