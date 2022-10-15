import 'package:flutter/material.dart';
import 'toppage.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(title: 'Welcome to Flutter', home: Home());
  }
}

class Home extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
          child: TextButton(
        child: Text('トップページへ'),
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
