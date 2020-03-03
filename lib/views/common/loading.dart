/*
 * @Date: 2020-02-18 10:38:59
 * @LastEditors: Quincy
 * @LastEditTime: 2020-03-02 22:37:53
 * @Description: 通用错误信息页
 */
import 'package:flutter/material.dart';
import 'package:by_flutter/views/common/navigationBar.dart';

class CommonLoadingPage extends StatelessWidget {
  CommonLoadingPage({Key key, this.text, this.title}) : super(key: key);
  final String text;
  final String title;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title ?? '页面加载中'),
      ),
      bottomNavigationBar: NavigationBar(),
      body: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            CircularProgressIndicator(),
            Container(
              padding: EdgeInsets.all(10),
              child: Text(text ?? "加载中..."),
            ),
          ],
        ),
      ),
    );
  }
}
