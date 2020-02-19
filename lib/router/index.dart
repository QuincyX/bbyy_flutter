import 'package:flutter/material.dart';
import '../views/home/index.dart' show FeedListHomePage;
import '../views/feed/detail.dart' show FeedDetailPage;

final routes = <String, WidgetBuilder>{
  "/": (context) => FeedListHomePage(title: 'BY live demo home page'),
  "/feed/detail": (context) => FeedDetailPage(),
};
