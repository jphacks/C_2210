import 'package:flutter/material.dart';
import 'main.dart';

class TopPage extends StatefulWidget {
  @override
  _TopPageState createState() => _TopPageState();
}

class _TopPageState extends State<TopPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
          child: TextButton(
        child: Text('home'),
        onPressed: () {
          Navigator.pop(context);
        },
      )),
    );
  }
}
