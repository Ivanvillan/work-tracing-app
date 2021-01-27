import 'package:flutter/material.dart';
import 'package:malatesta_app/home/home.dart';

import 'package:malatesta_app/user/login.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  // This widget is the root of your application.
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  var isLogin = false;

  @override
  void initState() {
    super.initState();
    checkLogin();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: isLogin
          ? Home(
              state: 'all',
            )
          : Login(),
    );
  }

  checkLogin() async {
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    var cookies = localStorage.getString('cookies');
    if (cookies != null) {
      setState(() {
        isLogin = true;
      });
    }
  }
}
