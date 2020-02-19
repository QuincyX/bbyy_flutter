import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';

import 'package:by_flutter/plugins/dio.dart' show $http;
import 'package:by_flutter/store/index.dart';
import 'package:by_flutter/views/home/recommends.dart' show RecommendsFeedList;
import 'package:by_flutter/views/home/follow.dart' show FollowFeedList;
import 'package:by_flutter/views/home/lastest.dart' show LastestFeedList;
import 'package:by_flutter/views/home/tag.dart' show TagFeedList;

class FeedListHomePage extends StatefulWidget {
  FeedListHomePage({Key key, this.title}) : super(key: key);
  final String title;
  @override
  _FeedListHomePageState createState() => _FeedListHomePageState();
}

class _FeedListHomePageState extends State<FeedListHomePage>
    with SingleTickerProviderStateMixin {
  TabController _tabController;
  List tabs = [];

  Future getNavigation() async {
    Response response =
        await $http.get('major-service/major/v1/navigation/select');
    tabs = response.data['data'].toList();
  }

  @override
  void initState() {
    super.initState();
    _tabController = TabController(
      length: 14,
      initialIndex: 1,
      vsync: this,
    );
    _tabController.addListener(() {
      switch (_tabController.index) {
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: getNavigation(),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if ((snapshot.connectionState == ConnectionState.done)) {
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
                  bottom: PreferredSize(
                    preferredSize: Size.fromHeight(48),
                    child: Material(
                      color: Colors.white,
                      child: TabBar(
                        controller: _tabController,
                        isScrollable: true,
                        labelColor: Colors.red[500],
                        labelStyle: TextStyle(
                          fontSize: 22,
                        ),
                        unselectedLabelColor: Colors.black,
                        unselectedLabelStyle: TextStyle(
                          fontSize: 14,
                        ),
                        tabs: tabs
                            .map((e) => Tab(
                                  text: e['name'],
                                ))
                            .toList(),
                      ),
                    ),
                  ),
                ),
                body: TabBarView(
                  controller: _tabController,
                  children: tabs.map((e) {
                    return Column(
                      children: <Widget>[
                        Expanded(
                          flex: 0,
                          child: StoreConnector<AppReduxStore, String>(
                            converter: (store) => store.state.user.toString(),
                            builder: (context, counter) {
                              return Text(counter);
                            },
                          ),
                        ),
                        Expanded(
                          child: _FeedListTabViewContent(
                            type: e['url'] ?? 'index',
                          ),
                        ),
                      ],
                    );
                  }).toList(),
                ),
                floatingActionButton: StoreConnector<AppReduxStore, dynamic>(
                  converter: (store) => store,
                  builder: (context, store) {
                    return FloatingActionButton(
                      onPressed: () {
                        store.dispatch(
                            {'module': 'user', 'type': 'counterPlus'});
                      },
                      child: Icon(Icons.add),
                    );
                  },
                ),
              );
            }
          } else {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
        });
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

class _FeedListTabViewContent extends StatelessWidget {
  _FeedListTabViewContent({Key key, this.type}) : super(key: key);
  final String type;
  Widget build(BuildContext context) {
    if (type == 'index') {
      return RecommendsFeedList();
    } else if (type == 'follow') {
      return FollowFeedList();
    } else if (type == 'lastest') {
      return LastestFeedList();
    } else if (type == 'tag') {
      return TagFeedList(
        tagId: int.parse(type?.substring(4)),
      );
    } else {
      return RecommendsFeedList();
    }
  }
}
