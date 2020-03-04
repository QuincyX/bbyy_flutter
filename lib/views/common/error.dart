/*
 * @Date: 2020-02-18 10:38:59
 * @LastEditors: Quincy
 * @LastEditTime: 2020-02-18 13:59:00
 * @Description: 通用错误信息页
 */
import 'package:flutter/material.dart';

class CommonErrorPage extends StatelessWidget {
  CommonErrorPage({Key key, this.text}) : super(key: key);
  final String text;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("错误"),
      ),
      body: Container(
        padding: EdgeInsets.all(20),
        child: Center(
          child: Text("Error: $text"),
        ),
      ),
    );
  }
}
