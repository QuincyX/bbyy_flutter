import 'package:flutter/material.dart';

class ErrorMessagePage extends StatelessWidget {
  ErrorMessagePage({Key key, this.text}) : super(key: key);
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
