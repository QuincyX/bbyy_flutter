import 'package:flutter/material.dart';
import './plugins/dio.dart';
import './store/global.dart';
import './views/home/index.dart' show FeedListHomePage;
import './views/feed/detail.dart' show FeedDetailPage;

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  Global.init().then((e) {
    initHttpInstance();
    runApp(MyApp());
  });
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'BY live demo',
      theme: ThemeData(
        primarySwatch: Colors.yellow,
      ),
      routes: {
        "/": (context) => FeedListHomePage(title: 'BY live demo home page'),
        "/feed/detail": (context) => FeedDetailPage(),
        "feed_follow": (context) =>
            FeedListHomePage(title: 'BY live demo home /follow'),
        "feed_lastest": (context) =>
            FeedListHomePage(title: 'BY live demo home /lastest'),
        "feed_tag": (context) =>
            FeedListHomePage(title: 'BY live demo home /tag'),
      },
    );
  }
}
