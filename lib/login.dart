import 'package:flutter/material.dart';
import 'main.dart';
import 'toppage.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
          child: TextButton(
        child: Text('ログイン'),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => TopPage()),
          );
        },
      )),
    );
  }
}
