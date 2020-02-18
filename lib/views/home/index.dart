import 'package:flutter/material.dart';
import '../../plugins/dio.dart' show $http;
import './recommends.dart' show RecommendsFeedList;
import './follow.dart' show FollowFeedList;
import './lastest.dart' show LastestFeedList;
import './tag.dart' show TagFeedList;

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
    var response = await $http.get('major-service/major/v1/navigation/select');
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
                          child: FeedListTabViewContent(type: e['url']),
                        ),
                      ],
                    );
                  }).toList(),
                ),
                floatingActionButton: FloatingActionButton(
                  onPressed: () {
                    showMessageDialog(context);
                  },
                  child: Icon(Icons.add),
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

class FeedListTabViewContent extends StatelessWidget {
  FeedListTabViewContent({Key key, this.type}) : super(key: key);
  final String type;
  Widget build(BuildContext context) {
    if (type == 'index') {
      return RecommendsFeedList();
    } else if (type == 'follow') {
      return FollowFeedList();
    } else if (type == 'lastest') {
      return LastestFeedList();
    } else {
      return TagFeedList(tagId: int.parse(type.substring(4)));
    }
  }
}
