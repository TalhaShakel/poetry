// import 'dart:html';

import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:poetry_publisher/main.dart';
import 'package:poetry_publisher/screens/Auth%20Screens/login.dart';
import 'package:poetry_publisher/screens/trending/trending_home.dart';
import 'package:poetry_publisher/screens/user%20upload%20poetry/upload_home.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ruff extends StatefulWidget {
  ruff({Key? key}) : super(key: key);

  @override
  State<ruff> createState() => _ruffState();
}

class _ruffState extends State<ruff> {
  int _page = 0;
  var login3;

  final GlobalKey<CurvedNavigationBarState> _bottomNavigationKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: CurvedNavigationBar(
        key: _bottomNavigationKey,
        index: 0,
        height: 60.0,
        items: <Widget>[
          Icon(Icons.home, size: 30),
          // Icon(Icons.add, size: 30),
          Icon(Icons.trending_up_outlined, size: 30),
          // Icon(Icons.compare_arrows, size: 30),
        ],
        color: Colors.white,
        buttonBackgroundColor: Colors.white,
        backgroundColor: Colors.blueAccent,
        animationCurve: Curves.easeInOut,
        animationDuration: Duration(milliseconds: 600),
        onTap: (index) async {
          SharedPreferences prefs = await SharedPreferences.getInstance();

          login3 = prefs.getString("email");

          setState(() {
            _page = index;
          });
        },
        letIndexChange: (index) => true,
      ),
      body: _page == 0
          ? home_page()
          : _page == 1
              // ? login3 == null
              //     ? login()
              //     : upload()
              // ?_page == 2
              ? trending()
              : home_page(),
    );
  }
}
