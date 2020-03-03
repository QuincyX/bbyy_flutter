import 'package:flutter/material.dart';
import '../views/home/index.dart' show FeedListHomePage;
import '../views/feed/detail.dart' show FeedDetailPage;
import '../views/feed/index.dart' show RecommendsFeedList;
import '../views/profile/index.dart' show ProfileHomePage;

final routes = <String, WidgetBuilder>{
  "/": (context) => FeedListHomePage(title: 'BY live demo home page'),
  "/feed/index": (context) => RecommendsFeedList(),
  "/feed/detail": (context) => FeedDetailPage(),
  "/message/index": (context) => RecommendsFeedList(),
  "/profile/index": (context) => ProfileHomePage(),
};
