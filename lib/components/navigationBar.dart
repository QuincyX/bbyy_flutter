import 'package:flutter/material.dart';

class NavigationBar extends StatefulWidget {
  NavigationBar({
    Key key,
    this.currentIndex,
  }) : super(key: key);

  final int currentIndex;

  @override
  _State createState() => _State();
}

class _State extends State<NavigationBar> {
  int _currentIndex;
  List _navigationList = [
    {'name': "首页", 'icon': Icon(Icons.home), 'page': '/home/index'},
    {'name': "消息", 'icon': Icon(Icons.message), 'page': '/message/index'},
    {'name': "发现", 'icon': Icon(Icons.toys), 'page': '/feed/index'},
    {'name': "我", 'icon': Icon(Icons.person), 'page': '/profile/index'},
  ];

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.currentIndex ?? 0;
  }

  void _onNavigationTap(int index) {
    setState(() {
      _currentIndex = index;
    });
    Navigator.pushReplacementNamed(context, _navigationList[index]['page']);
  }

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: _currentIndex,
      onTap: _onNavigationTap,
      unselectedItemColor: Colors.black,
      selectedItemColor: Colors.amber[800],
      type: BottomNavigationBarType.fixed,
      showUnselectedLabels: true,
      items: _navigationList
          .map((i) => BottomNavigationBarItem(
                icon: i['icon'],
                title: Text(i['name']),
              ))
          .toList(),
    );
  }
}
